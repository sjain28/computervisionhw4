function [phi, used] = trainForest(T, M)
    phi = [];
    N = numel(T.X(:,1));
    used = false(N,M);
    phi = repmat({struct('d',{}, 't',{}, 'L',{}, 'R',{}, 'p',{})}, 1, N);
    for i=1:M
        r = round(1 + (N-1) * rand(N, 1));
        used(r,i) = true;
        S = {};
        S.X = T.X(r,:);
        S.y = T.y(r);
        S.labelMap = T.labelMap;
        tau = trainTree(S, 0, true, Inf, 1);
        % should this be union?
        phi{i} = tau;
    end
        

end

