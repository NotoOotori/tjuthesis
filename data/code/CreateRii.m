function  [Rii,NumRii] = CreateRii(elem,ELEM,delta,fine2coarsenode,bdnode)
%% Restriction Operator Ri from Constructing Fine Space to Domain Decomposition Space Vi

NE = size(ELEM,1);
ne = size(elem,1);
Rii = zeros(NE,1);
NumRii = zeros(NE,1);
if delta == 1
    for ii = 1:NE
        temp = setdiff(fine2coarsenode(ii,:),bdnode);
        % Fine points of interior nodes
        NumRii(ii) = length(temp);
        Rii(ii,1:NumRii(ii)) = temp;
        % interior fine points on each coarse element
    end
else
    delta = delta-1;
    tempnode = fine2coarsenode;
    temparray = 1:ne;
    for kk = 1:delta
        for ii = 1:NE
            % Find the fine element which intersects the coarse element 
            elem1 = ismember(elem(:,1),tempnode(ii,:));
            % Whether the first node of the fine element is in the detailed point of the coarse element, and so on
            elem1 = temparray(elem1);
            % A fine element that has an intersection with a coarse element
            elem2 = ismember(elem(:,2),tempnode(ii,:));
            elem2 = temparray(elem2);
            elem3 = ismember(elem(:,3),tempnode(ii,:));
            elem3 = temparray(elem3);
            tempelem = unique([elem1,elem2,elem3]);
            temp = elem(tempelem,:);
            % pick out these elements
            temp = temp(:);
            temp = unique(temp);
            % Internal fine points of each overlapping coarse area
            NumRii(ii) = length(temp);
            tempnode(ii,1:NumRii(ii))= temp;
            % Internal points of each overlapping coarse area
        end
    end

    for ii = 1:NE
        % remove boundary nodes
        temp = setdiff(tempnode(ii,1:NumRii(ii)),bdnode);
        % pick out the interior fine points
        NumRii(ii) = length(temp);
        % The number of fine points in each overlapping area
        Rii(ii,1:NumRii(ii)) = temp;
    end
end

end

