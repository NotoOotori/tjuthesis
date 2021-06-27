function y = DDM_LOD(x,A,ACoarse,CoarseNodeBase,Rii,NumRii,freenode,freeNodeCoarse)
%% Calculate the domain decomposition equation
%% y = R_0^T(A^H)^{-1}R_0 + sum_{i=1}^{N}R^{(i)}^T(A^{(i)})^{-1}R^{(i)}
%% The extension operator is to make the dimensions consistent, in the finest space

n = size(A,1);
z = zeros(n,1);
z(freenode) = x; 
NE = size(Rii,1); 
% split the matrix calculation
P = CoarseNodeBase(freenode,freeNodeCoarse); 
% extension operator
y0 = P'*x; % R0*x
y0 = ACoarse\y0; % A0^(-1)*R0*x
y0 = P*y0; % R0^T*A0^(-1)*R0*x
y1 = zeros(n,1);

for ii = 1:NE
    idx = Rii(ii,1:NumRii(ii)); 
    % fine nodes in the overlapping coarse domain
    xsub = z(idx);
    Asub = A(idx,idx);
    xsub = Asub\xsub; % Ri^T*Ai^(-1)*Ri*x
    y1(idx) =y1(idx) + xsub;
end

y = y0 + y1(freenode);

end

