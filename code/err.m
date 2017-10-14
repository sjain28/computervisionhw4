function e = err(f, S)
    numSamples = double(numel(S.y));
    numErrors = double(0);
    
    for i = 1:numSamples
        if f(S.X(i,:)) ~= S.y(i)
            numErrors = numErrors+1;
        end
    end
    
    e = numErrors/numSamples;
    
end