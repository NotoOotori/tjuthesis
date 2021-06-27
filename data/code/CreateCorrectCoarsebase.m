function CoarseNodeBase = CreateCorrectCoarsebase(CoarseElemBase,fine2coarseelem,fine2coarsenode,elem,elemCoarse,n,N)
%% Construct a extension (transfer) operator from coarse to fine space
%% R_0^T

NE = size(elemCoarse,1);
% number of coarse elements
CoarseNodeBase = zeros(n,N);
NN = length(fine2coarsenode(1,:));
% Number of fine nodes on one coarse element
for kk = 1:NE
    [bdtemp,~,~] = findboundary(elem(fine2coarseelem(kk,:),:));
    % Fine points at the boundary of coarse elements
    LIA = ismember(fine2coarsenode(kk,:),bdtemp);
    % Mark the position of the element boundary node
    CoarseElemBase(kk,LIA,:) = CoarseElemBase(kk,LIA,:)/2; 
    % The value of the basis function at the boundary node at the minutiae point is composed of two adjacent elements
    for ii = 1:3
        conner = elemCoarse(kk,ii);
        % Vertices of coarse elements
        lia = ismember(fine2coarsenode(kk,:),conner);
        % Mark the position of the vertex
        CoarseElemBase(kk,lia,ii) = CoarseElemBase(kk,lia,ii)/3; 
        % The value of the basis function at the vertex on the node is composed of 6 adjacent elements
    end
    for ii = 1:3
        CoarseNodeBase = CoarseNodeBase + sparse(fine2coarsenode(kk,:),repmat(elemCoarse(kk,ii),NN,1),CoarseElemBase(kk,:,ii),n,N);
    end
end

end

