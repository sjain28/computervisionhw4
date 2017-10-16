function tau = trainTree(S, depth, random, dMax, sMin)

delta = sqrt(eps);

if depth == 0
    if nargin < 3 || isempty(random)
        random = false;
    end
    
    if nargin < 4 || isempty(dMax)
        dMax = Inf;
    end
    
    if nargin < 5 || isempty(sMin)
        sMin = 1;
    end
end

tau.d = [];
tau.t = [];
tau.L = [];
tau.R = [];
tau.p = [];

if OkToSplit(S, depth)
    [Ltemp, Rtemp, tau.d, tau.t] = findSplit(S);
    
    %Handling edge case where splitting is not possible,
    %but OkToSplit returns true
    if numel(Rtemp.y) == 0
        tau.p = distribution(S);        
    else
    	tau.L = trainTree(Ltemp, depth+1, random, dMax, sMin);
        tau.R = trainTree(Rtemp, depth+1, random, dMax, sMin);
    end

else
    tau.p = distribution(S);
end

%%
    function answer = OkToSplit(S, depth)
        answer = impurity(S) > 0 & depth < dMax & numel(S.X(:,1)) > sMin;
    end
%%
    function [LOpt, ROpt, dOpt, tOpt] = findSplit(S)
        if random
            [LOpt, ROpt, dOpt, tOpt] = findSplitR(S);
        else
        DeltaOpt = -1;
        im = impurity(S);
        featureSize = double(size(S.X));
        numDims = featureSize(2);

        for i = 1:numDims
            dimValues = S.X(:,i);
            thresholds = sort(unique(dimValues));
            for j = 1:numel(thresholds)
               
                if j < numel(thresholds)
                    thresh = (double(thresholds(j)) ...
                        + double(thresholds(j+1)))/2;
                else
                    thresh = thresholds(j);
                end
                
                left.X = S.X(S.X(:,i) <= thresh,:);
                right.X = S.X(S.X(:,i) > thresh,:);
                
                left.y = S.y(S.X(:,i) <= thresh,:);
                right.y = S.y(S.X(:,i) > thresh,:);
                
                left.labelMap = S.labelMap;
                right.labelMap = S.labelMap;
                
                leftSize = double(size(left.X));
                rightSize = double(size(right.X));
                
                Delta = im - impurity(left)*leftSize(1)/featureSize(1) ...
                    - impurity(right)*rightSize(1)/featureSize(1);
                Delta = fix(Delta, S, left, right);
                
                if Delta > DeltaOpt
                    DeltaOpt = Delta;
                    LOpt = left;
                    ROpt = right;
                    dOpt = i;
                    tOpt = thresholds(j);
                end
            end
        end
        

        end
    end
%%
    function p = distribution(S)
        p = double(zeros(numel(S.labelMap)));
        for i = 1:numel(S.labelMap)
            p(i) = sum(S.y == S.labelMap(i)); 
        end
        p = p/numel(S.y);
    end
%%
    function i = impurity(S)
        m = mode(S.y);
        nonModeCount = double(sum(S.y ~= m));
        i = nonModeCount/numel(S.y);
        i = clip(i);
    end

%%
    function [LOpt, ROpt, dOpt, tOpt] = findSplitR(S)
        DeltaOpt = -1;
        im = impurity(S);
        featureSize = double(size(S.X));
        numDims = featureSize(2);
        dim = randi(numDims);
        
        dimValues = S.X(:,dim);
        thresholds = sort(unique(dimValues));
        for j = 1:numel(thresholds)
            
                if j < numel(thresholds)
                    thresh = (double(thresholds(j)) ...
                        + double(thresholds(j+1)))/2;
                else
                    thresh = thresholds(j);
                end
            
            left.X = S.X(S.X(:,dim) <= thresh,:);
            right.X = S.X(S.X(:,dim) > thresh,:);
            
            left.y = S.y(S.X(:,dim) <= thresh,:);
            right.y = S.y(S.X(:,dim) > thresh,:);
            
            left.labelMap = S.labelMap;
            right.labelMap = S.labelMap;
            
            leftSize = double(size(left.X));
            rightSize = double(size(right.X));
            
            Delta = im - impurity(left)*leftSize(1)/featureSize(1) ...
                - impurity(right)*rightSize(1)/featureSize(1);
            Delta = fix(Delta, S, left, right);
            
            if Delta > DeltaOpt
                DeltaOpt = Delta;
                LOpt = left;
                ROpt = right;
                dOpt = dim;
                tOpt = thresholds(j);
            end
        end
    end

%%
    % Do not change the code in the functions count, clip and fix below
    function c = count(S)
        c = histcounts(S.y, (0:length(S.labelMap)) + 0.5);
    end

    function x = clip(x)
        if abs(x) < delta
            x = 0;
        end
    end

    function Delta = fix(Delta, S, L, R)
        Delta = map(Delta, 0, 0.5, delta, 0.5);
        cS = count(S);
        cL = count(L);
        cR = count(R);
        zL = nnz(cL) == 1;
        zR = nnz(cR) == 1;
        if nnz([zL zR]) == 1
            % Exactly one of L, R is pure. Call that P, and the other one Q
            cP = cL;
            cQ = cR;
            if zR
                cP = cR;
                cQ = cL;
            end
            [mP, lP] = max(cP);
            [mS, lS] = max(cS);
            if lP == lS % The only label of P is the majority label of S
                % Make a larger P have a higher delta, but below any
                % genuinely nonzero delta
                [~, lQ] = max(cQ);
                if lQ == lS % The majority label of Q is the majority label of S
                    Delta = 0.9 * delta * mP / mS;
                end
            end
        end
        
        function x = map(x, a, b, c, d)
            if abs(a - b) < delta
                error('a=%g is too close to b=%g', a, b)
            end
            m = 1/(a - b);
            u = (c - d) * m;
            v = (d * a - c * b) * m;
            x = u * x + v;
        end
    end
end