function e = oobErr(phi, T, used)
    numSamples = double(numel(T.y));
    err = double(0);
    for i = 1:numSamples
        sample = T.X(i,:);
        oobTrees = phi(used(i,:) ~= 1);
        
        if numel(oobTrees) == 0
            continue;
        end
        
        oobClass = forestClassify(sample, oobTrees);
        if oobClass ~= T.y(i)
            err = err+1;
        end
    end
    
    e = err/numSamples;
end



