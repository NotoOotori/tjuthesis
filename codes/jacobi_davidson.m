function [lambda,u,lambda_list] = jacobi_davidson(A,M,freenode,u0,node,elem,NODE,ELEM,option)
%% 两水平加性Schwartz预条件子处理的Jacobi-Davidson迭代求解最小特征值算法
    if ~exist('option','var')
        option.tol = 1e-5;
        option.lambda_real = 2;
        % 停机准则的参数
    end
    u = u0/norm(u0);
    U = u;
    A_free = A(freenode,freenode); 
    % 原矩阵由于边界条件的存在是半正定的,需要
    % 取内部自由度才是正定矩阵
    M_free = M(freenode,freenode); 
    lambda = dot(A_free*u,u)/dot(M_free*u,u);
    lambda_old = 1e5;
    err = abs(lambda-lambda_old);
    lambda_list = [];
    iter = 0;
    while err>option.tol
        % 有限元真解不知道的情况下应以迭代误差小于tol为准
        lambda_old = lambda;
        r = -A_free*u + lambda.*M_free*u;
        t = twolevel_precondition(A,M,r,u,lambda,node,elem,NODE,ELEM,freenode);
        % 校正方程
        t = t/norm(t);
        U = [U t]; 
        % 扩展搜索空间
        A_tilde = U'*A_free*U;
        M_tilde = U'*M_free*U;
        [u,lambda] = eigs(A_tilde,M_tilde,1,'smallestabs');
        % 通常是不大于20x20的特征值问题,不必再用专门的算法求解,直接套用MATLAB求解器
        u = U*u;
        iter = iter + 1;
        if iter > size(A_free,1)
            error('迭代未收敛');
        end
        err = abs(lambda-lambda_old);
        lambda_list = [lambda_list lambda];
    end
    fprintf('迭代在%d步后终止,计算特征值为%f\n',iter,lambda);
end