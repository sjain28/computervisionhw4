function y = forestClassify(x, phi)
    
    t = phi(1);
    while(~isempty(t.d))
        t = t.L;
    end
    
    vec = arrayfun(@(y) treeClassify(x, y), phi);
    y = mode(vec);

end

