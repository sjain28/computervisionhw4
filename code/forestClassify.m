function y = forestClassify(x, phi)
    p = [];
    t = tau.L;
    while(~isempty(tau.d))
        t = t.L;
    end
    % is this the correct dimension to take for num of classes?
    K = numel(t.p(:,1));
    
    v = zeros(K);
    for i = 1:numel(phi)
       tau = phi{i};
       y = treeClassify(x, tau);
       v(y) = v(y) + 1;
    end
    
    [argval, y] = max(v);

end

