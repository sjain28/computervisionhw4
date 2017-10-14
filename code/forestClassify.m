function y = forestClassify(x, phi)

    t = phi{1};
    while(~isempty(t.d))
        t = t.L;
    end
 
    K = numel(t.p);
    
    v = zeros(K);
    for i = 1:numel(phi)
       tau = phi{i};
       y = treeClassify(x, tau);
       v(y) = v(y) + 1;
    end
    
    [~, y] = max(v);

end

