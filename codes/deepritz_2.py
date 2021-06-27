# -*- coding: utf-8 -*-

import torch 
import torch.nn.functional as F
import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
from scipy.sparse import csr_matrix
from scipy.io import savemat,loadmat

class DeepRitzNet(torch.nn.Module):
    def __init__(self, in_dim,m,out_dim):
        super(DeepRitzNet, self).__init__()
        self.linear1 = torch.nn.Linear(in_dim,m)
        self.linear2 = torch.nn.Linear(in_dim+m,m)
        self.linear3 = torch.nn.Linear(in_dim+2*m,out_dim)
        
    def forward(self,x):
        x0 = x
        y1 = F.relu(self.linear1(x))
        x1 = torch.cat((x0,y1),dim=1)
        y2 = F.relu(self.linear2(x1))
        x2 = torch.cat((x1,y2),dim=1)
        y3 = self.linear3(x2)
        output = y3
        return output
    
def get_interior_points(N=10000, d=2):
    """
    randomly sample N points from interior of [0,1]^d
    """
    return torch.rand(N, d) 

def boundary_func(x):
    return torch.unsqueeze(x[:,0]*(1-x[:,0])*x[:,1]*(1-x[:,1]),1)

def grad_boundary_func(x):
    return torch.cat((torch.unsqueeze(x[:,1]*(1-x[:,1])*(1-2*x[:,0]),1),\
                      torch.unsqueeze(x[:,0]*(1-x[:,0])*(1-2*x[:,1]),1)),dim=1)

def train(model, opt, initial_lr=1e-2,milestones=[1000], gamma=0.5, 
    iterations=100000, beta=10000, beta_increase=1.01, print_every_iter=1000):

    best_loss = 1e3
    lambdamin = 1e3
    if opt == 'Adam':
        optimizer = torch.optim.Adam(model.parameters(), lr=initial_lr)
    elif opt == 'SGD':
        optimizer = torch.optim.SGD(model.parameters(), lr=initial_lr)
    scheduler = torch.optim.lr_scheduler.MultiStepLR(optimizer, \
                                milestones=milestones, gamma=gamma)
    
    for _iter in range(iterations):
        loss = torch.zeros(1)
        
        sample_points_xi = get_interior_points()
        sample_points_eta = get_interior_points()
        sample_points_xi.requires_grad_()
        sample_points_eta.requires_grad_()
        phi_xi = model(sample_points_xi)
        phi_eta = model(sample_points_eta)

        grads_xi = torch.autograd.grad(outputs=phi_xi,inputs=sample_points_xi,
                                 grad_outputs=torch.ones_like(phi_xi),
                              create_graph=True, retain_graph=True, only_inputs=True)[0]        

        grads_tot = boundary_func(sample_points_xi)*grads_xi + \
                    grad_boundary_func(sample_points_xi)*phi_xi
                    
        norm_xi = torch.sum(torch.sum(torch.pow(grads_tot,2)))
        norm_eta = torch.sum\
        (torch.sum(torch.pow(boundary_func(sample_points_eta)*phi_eta,2)))
        
        rayleigh_quotient = norm_xi / norm_eta

        regularization = (0.0625*model(torch.tensor([[0.5,0.5]]))-1)**2
        loss = rayleigh_quotient + beta * regularization
        
        optimizer.zero_grad()
        loss.backward()
        scheduler.step()
        optimizer.step()
        
        if (_iter+1) %  print_every_iter == 0:
            beta *= beta_increase
            print('epoch:', _iter, 'loss:', loss.item())
        if (loss.item()<best_loss):
            best_loss = loss.item()
            torch.save(model.state_dict(), 'good.mdl')
            if(rayleigh_quotient.item()<lambdamin and rayleigh_quotient.item()>=2*np.pi**2):
                lambdamin = rayleigh_quotient.item()
    print('lambda_calculated:',lambdamin)
    
def drawgraph(model,device):
    model.load_state_dict(torch.load('good.mdl'))

    with torch.no_grad():
        x1 = torch.linspace(0, 1, 101)
        x2 = torch.linspace(0, 1, 101)
        X, Y = torch.meshgrid(x1, x2)
        Z = torch.cat((Y.flatten()[:, None], Y.T.flatten()[:, None]), dim=1)
        Z = Z.to(device)
        pred = model(Z) * boundary_func(Z)
        real = np.sin(np.pi*Z[:,0])*np.sin(np.pi*Z[:,1])
    plt.figure()
    pred = pred.cpu().numpy()
    pred = pred.reshape(101, 101)
    real = real.cpu().numpy()
    real = real.reshape(101,101)
    plt.figure(0)
    ax = plt.subplot(1, 1, 1)
    h1 = plt.imshow(pred, interpolation='nearest', cmap='rainbow',
                   extent=[0, 1, 0, 1],
                   origin='lower', aspect='auto')
    
    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    plt.colorbar(h1, cax=cax)
    plt.show()
    plt.figure(1)
    ax = plt.subplot(1, 1, 1)
    h2 = plt.imshow(real, interpolation='nearest', cmap='rainbow',
                   extent=[0, 1, 0, 1],
                   origin='lower', aspect='auto')
    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    plt.colorbar(h2, cax=cax)
    plt.show()
    ratio = real/pred
    print(ratio)
    print(np.nanmax(ratio[ratio!=np.inf]),np.nanmin(ratio[ratio!=-np.inf]))
    print(np.max(np.abs(real-pred)))


def savedata(radio2coarse,radio2fine,opt):
    node = np.array([[0,0],[1,0],[1,1],[0,1]])
    elem = np.array([[2,3,1],[4,1,3]])
    elem = elem-1
    Db = np.array([[1,2],[1,4],[2,3],[3,4]])
    Db = Db-1
    if opt != 'read':
        for i in range(radio2coarse):
            node,elem,Db = uniform_refine_2D(node,elem,Db)
        for i in range(radio2fine):
            node,elem,Db = uniform_refine_2D(node,elem,Db) 
    else:
        nn = loadmat('u0_deep'+str(radio2coarse)+str(radio2fine)+'.mat')
        node = nn['node']
        
    node = torch.tensor(node,dtype=torch.float)
    in_dim = 2
    m = 100
    out_dim = 1
    
    device = torch.device('cpu' if torch.cuda.is_available() else 'cpu')
    model = DeepRitzNet(in_dim,m,out_dim)
    model.to(device)    
    model.load_state_dict(torch.load('good.mdl'))
    
    with torch.no_grad():
        u0_deep = model(node)*boundary_func(node)
        u0_deep = u0_deep.cpu().detach().numpy()
    mdic = {"u0_deep":u0_deep}
    savemat("u0_deep"+str(radio2coarse)+str(radio2fine)+".mat",mdic)
    
    
def uniform_refine_2D(node,elem,Db):
    totalEdge = np.sort(np.concatenate((elem[:,[1,2]],elem[:,[2,0]],elem[:,[0,1]])))
    edge, j = np.unique(totalEdge,axis=0,return_inverse=True)
    N = np.shape(node)[0]
    NT = np.shape(elem)[0]
    NE = np.shape(edge)[0]
    elem2edge = np.reshape(j,(NT,3),order='F')
    node = np.concatenate((node,(node[edge[:,0],:]+node[edge[:,1],:])/2))
    edge2newnode = np.arange(N,N+NE)
    t = np.arange(0,NT)
    p = np.zeros((NT,6),dtype=int)
    for i in np.arange(0,NT): 
        p[i,np.arange(0,3)] = elem[i,np.arange(0,3)]
        p[i,np.arange(3,6)] = edge2newnode[elem2edge[i,np.arange(0,3)]]
    for i in range(0,NT):
        elem[i,:] = np.array([p[i,0],p[i,5],p[i,4]])
    elem = np.concatenate((elem,np.zeros((3*NT,3),dtype=int)))
    elem[np.arange(NT,2*NT),:] = np.transpose(np.array([p[t,5],p[t,1],p[t,3]]))
    elem[np.arange(2*NT,3*NT),:] = np.transpose(np.array([p[t,4],p[t,3],p[t,2]]))
    elem[np.arange(3*NT,4*NT),:] = np.transpose(np.array([p[t,3],p[t,4],p[t,5]]))
    A = csr_matrix((np.arange(0,NE),(edge[:,0],edge[:,1])),shape=(N,N))
    A = A + A.transpose()
    A = A.toarray()
    A = A.reshape((N*N,1),order='F')
    #A = A.tocsr()
    idx = Db[:,0]*N + Db[:,1]
    #idx = A[idx,0]
    #idx = idx.toarray()
    idx4newnode=edge2newnode[idx]
    Db1 = np.concatenate((np.expand_dims(Db[:,0],axis=1),idx4newnode),axis=1)
    Db2 = np.concatenate((np.expand_dims(Db[:,1],axis=1),idx4newnode),axis=1)
    Db = np.concatenate((Db1,Db2),axis=0)
    return node,elem,Db
    

def main(opt):
    in_dim = 2
    m = 100
    out_dim = 1
    radio2coarse = 2
    radio2fine = 8
    
    device = torch.device('cpu' if torch.cuda.is_available() else 'cpu')
    model = DeepRitzNet(in_dim,m,out_dim)
    model.to(device)
    if opt == 'test':
        savedata(radio2coarse,radio2fine,'read')
    else:
        train(model,'Adam')
    drawgraph(model,device)
    
    
if __name__ == '__main__':
    main('test')