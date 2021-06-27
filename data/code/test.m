clear;
radio2Coarse = 2; 
% 粗网格加密次数
radio2fine = 8;  
% 细网格的加密次数
NODE = [0 0; 1 0; 1 1; 0 1];
ELEM = [2 3 1; 4 1 3];
%ELEM = [1 2 3; 3 4 1];
DB = [1 2; 1 4; 2 3; 3 4];
%NODE = double(NODE);
%ELEM = double(ELEM);
%DB = double(DB);
for i = 1:radio2Coarse 
    % 初始网格加密得到粗网格
    [NODE,ELEM,DB] = uniformrefine_2D(NODE,ELEM,DB);
end
node = NODE;
elem = ELEM;
Db = DB;
for i = 1:radio2fine 
    % 在粗网格的基础上加密得到细网格
    [node,elem,Db] = uniformrefine_2D(node,elem,Db);
end
[A,M,freenode] = assemblingsparse(node,elem,Db); 
% 细网格上的质量和刚度矩阵
%[ACoarse,MCoarse,FREENODE] = assemblingsparse(NODE,ELEM,DB);
%% 粗网格上的质量和刚度矩阵
%u0 = ones(size(freenode',1),1);
% 随机初值
load u0_deep28;
u0 = double(u0_deep(freenode));
% 神经网络提供的初值
% load u026
% u0 = u0_new;%(freenode);
[lambda,u,lambda_list] = jacobi_davidson(A,M,freenode,u0,node,elem,NODE,ELEM);
plot_error(lambda_list);
