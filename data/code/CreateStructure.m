function [fine2coarseelem,freeNodeCoarse] = CreateStructure(ELEM,NCoarse,radio2Coarse,radio2fine)
%% fine2coarseelem:The serial number of the fine element on the coarse element

NECoarse = size(ELEM,1);

fine2coarseelem = zeros(NECoarse,4^radio2fine);
fine2coarseelem(:,1) = 1:NECoarse;
% The default first column label is the coarse element label
for ii = 1:radio2fine
    % Label the fine elements according to the element arrangement order of the uniformrefine_2D grid refinement (label by column)£¬
    % Label every 4 columns
    temp = fine2coarseelem(:,1:2^(2*ii-2));
    tempadd = 2^(2*(radio2Coarse+ii)-1);
    % number of coarse elements: 2^(2*(radio2Coarse+ii)-1)
    fine2coarseelem(:,1:2^(2*ii)) = [temp temp+tempadd ...
                            temp+2*tempadd temp+3*tempadd];
    % The number of the fine element contained in each coarse element is obtained from the refined number
end

temp = 1:NCoarse;
% numbering coarse nodes
[~,~,isBdNodeCoarse] = findboundary(ELEM);
% Coarse grid boundary node marking
freeNodeCoarse = temp(~isBdNodeCoarse);
% Coarse grid free boundary node marking
end

