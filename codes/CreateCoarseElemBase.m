function [ CoarseElemBase,fine2coarsenode ] = CreateCoarseElemBase(node,elem,ELEM,radio2fine,fine2coarseelem,area)
%% The value of the basis function of each coarse node on the coarse element at the fine point (area ratio)

NE = size(fine2coarseelem,1);% number of coarse elements
ne0 = 1;
% number of initial elements
e0 = 3;
% number of initial edges
n0 = 3;
% number of initial nodes
for ii = 1:radio2fine
    n0 = e0+n0;
    % Update the number of nodes (the original number of nodes + the number of edges (only add nodes on the edges))
    e0 = 2*e0+3*ne0;
    % Update of the number of edges (each edge is divided into two edges, and each unit adds three edges)
    ne0 = 4*ne0;
    % Number of elements updated (each element becomes four elements)
end

fine2coarsenode = zeros(NE,n0);
CoarseElemBase = zeros(NE,n0,3);

for ii = 1:NE  
    % Cycle the coarse element (select nodes on the coarse element on the fine element) 
    temp1 = elem(fine2coarseelem(ii,:),1);  
    % The first node of the fine element, and so on
    temp2 = elem(fine2coarseelem(ii,:),2);  
    temp3 = elem(fine2coarseelem(ii,:),3);  
    temp = unique([temp1;temp2;temp3]);
    fine2coarsenode(ii,:) = temp;
    
    ve1 = node(temp,:)-repmat(node(ELEM(ii,1),:),n0,1);
    ve2 = node(temp,:)-repmat(node(ELEM(ii,2),:),n0,1);
    ve3 = node(temp,:)-repmat(node(ELEM(ii,3),:),n0,1);
    
    area1 = 0.5*(-ve3(:,1).*ve2(:,2) + ve3(:,2).*ve2(:,1));
    % The area of the triangle formed by the fine point and two coarse nodes
    idx = (area1<0); 
    area1(idx,:) = -area1(idx,:);
    CoarseElemBase(ii,:,1) = area1./area(ii);
    
    area2 = 0.5*(-ve1(:,1).*ve3(:,2) + ve1(:,2).*ve3(:,1));
    idx = (area2<0); 
    area2(idx,:) = -area2(idx,:);
    CoarseElemBase(ii,:,2) = area2./area(ii);
    
    area3 = 0.5*(-ve2(:,1).*ve1(:,2) + ve2(:,2).*ve1(:,1));
    idx = (area3<0); 
    area3(idx,:) = -area3(idx,:);
    CoarseElemBase(ii,:,3) = area3./area(ii);
end
end

