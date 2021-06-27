function [Dlambda,area,elemSign] = gradbasis(node,elem)
% Copyright (C) Long Chen. See COPYRIGHT.txt for details. 

NT = size(elem,1);
% $\nabla \phi_i = rotation(l_i)/(2|\tau|)$
ve1 = node(elem(:,3),:)-node(elem(:,2),:);
ve2 = node(elem(:,1),:)-node(elem(:,3),:);
ve3 = node(elem(:,2),:)-node(elem(:,1),:);
area = 0.5*(-ve3(:,1).*ve2(:,2) + ve3(:,2).*ve2(:,1));
Dlambda(1:NT,:,3) = [-ve3(:,2)./(2*area), ve3(:,1)./(2*area)];
Dlambda(1:NT,:,1) = [-ve1(:,2)./(2*area), ve1(:,1)./(2*area)];
Dlambda(1:NT,:,2) = [-ve2(:,2)./(2*area), ve2(:,1)./(2*area)];

% When the triangle is not positive orientated, we reverse the sign of the
% area. The sign of Dlambda is always right since signed area is used in
% the computation.
idx = (area<0); 
area(idx,:) = -area(idx,:);
elemSign = ones(NT,1);
elemSign(idx) = -1;