function plot_error(lambda_list)
%% 画误差随迭代次数变化的图
    n = length(lambda_list);
    err_list = lambda_list-lambda_list(end);
    err_ratio = zeros(n-1,1);
    for i = 2:n
        err_ratio(i) = err_list(i)/err_list(i-1);
    end
    plot(err_ratio(2:n-1));
end

