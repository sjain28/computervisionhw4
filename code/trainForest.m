function [phi, used] = trainForest(T, M)
    tic;
    N = numel(T.X(:,1));
    used = false(N,M);
    for i=1:M
        r = round(1 + (N-1) * rand(N, 1));
        used(r,i) = true;
        S = {};
        S.X = T.X(r,:);
        S.y = T.y(r);
        S.labelMap = T.labelMap;
        tau = trainTree(S, 0, true, Inf, 1);
        phi(i) = tau;
    end
    toc;
        

end

