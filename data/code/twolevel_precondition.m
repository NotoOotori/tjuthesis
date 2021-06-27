function t = twolevel_precondition(A,M,r,u,lambda,node,elem,NODE,ELEM,freenode,option)
%% 预条件子处理的校正方程   
    if ~exist('option','var')
        radio2Coarse = 2;
        radio2fine = 8;
        delta = 2;
    else
        radio2Coarse = option.radio2Coarse;
        radio2fine = option.radio2fine;
        delta = option.delta;
    end
    NECoarse = size(ELEM,1); 
    % 粗单元的个数
    NCoarse = size(NODE,1); 
    % 粗节点的个数

    nefine = size(elem,1); 
    % 细单元的个数

    nfine = size(node,1); 
    % 细节点的个数

    temp = 1:nfine;
    bd= true(nfine,1);
    bd(freenode)= false;
    bdnode =temp(bd); 
    % 细网格上边界节点
    [fine2coarseelem,freeNODE] = CreateStructure(ELEM,NCoarse,radio2Coarse,radio2fine);
    
    [~,AREA] = gradbasis(NODE,ELEM); 
    % 粗网格单元面积
    [ CoarseElemBase,fine2coarsenode] = CreateCoarseElemBase(node,elem,ELEM,radio2fine,fine2coarseelem,AREA);
    % 粗网格到细网格的插值
    
    CoarseNodeBase = CreateCorrectCoarsebase(CoarseElemBase,fine2coarseelem,fine2coarsenode,elem,ELEM,nfine,NCoarse);
    % 粗空间的节点基函数（延拓算子R_0^T）
    
    [Rii,NumRii] = CreateRii(elem,ELEM,delta,fine2coarsenode,bdnode);
    % 子区域的限制算子（Rii表示内部节点，NumRii内部节点个数）
    
    ACoarse = CoarseNodeBase(freenode,freeNODE)' * A(freenode,freenode) * CoarseNodeBase(freenode,freeNODE);
    MCoarse = CoarseNodeBase(freenode,freeNODE)' * M(freenode,freenode) * CoarseNodeBase(freenode,freeNODE);
    % 粗网格上的刚度矩阵和刚度矩阵
    
    r_new = DDM_LOD(r,A-lambda.* M,ACoarse-lambda.* MCoarse,CoarseNodeBase,Rii,NumRii,freenode,freeNODE);
    u_new = DDM_LOD(u,A-lambda.* M,ACoarse-lambda.* MCoarse,CoarseNodeBase,Rii,NumRii,freenode,freeNODE);
    % r_new,u_new对应于预条件子B^k处理后的rk和uk
    
    beta = - dot(r_new,u)/dot(u_new,u);
    t = r_new + beta * u_new; 
    % 更新搜索方向
end