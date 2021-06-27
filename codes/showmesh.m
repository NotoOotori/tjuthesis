function h = showmesh(node,elem,varargin)

% Copyright (C) Long Chen. See COPYRIGHT.txt for details.

dim = size(node,2);
nv = size(elem,2);
if (dim==2) && (nv==3) % planar triangulation
    h = trisurf(elem(:,1:3),node(:,1),node(:,2),zeros(size(node,1),1));
    set(h,'facecolor',[0.5 0.9 0.45],'edgecolor','k');
    view(2); axis equal; axis tight; axis off;
end
if (dim==2) && (nv==4) % planar quadrilateration
    h = patch('Faces', elem, 'Vertices', node);
    set(h,'facecolor',[0.5 0.9 0.45],'edgecolor','k');
    view(2); axis equal; axis tight; axis off;
end
if (dim==3) 
    if size(elem,2) == 3 % surface meshes
        h = trisurf(elem(:,1:3),node(:,1),node(:,2),node(:,3));    
        set(h,'facecolor',[0.5 0.9 0.45],'edgecolor','k','FaceAlpha',0.75);    
        view(3); axis equal; axis off; axis tight;    
    elseif size(elem,3) == 4
        showmesh3(node,elem,varargin{:});
        return
    end
end 
if (nargin>2) && ~isempty(varargin) % set display property
    if isnumeric(varargin{1})
        view(varargin{1});
        if nargin>3
            set(h,varargin{2:end});
        end
    else
        set(h,varargin{1:end});        
    end
end