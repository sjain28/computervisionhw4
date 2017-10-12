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

%% Your code here
if OkToSplit(S, depth)
    [Ltemp, Rtemp, tau.d, tau.t] = findSplit(S);
    tau.L = trainTree(L, depth+1, random, dMax, sMin);
    tau.R = trainTree(R, depth+1, random, dMax, sMin);
else
    tau.p = distribution(S);
end

%%
    function answer = OkToSplit(S, depth)
        answer = impurity(S) > 0 & depth < dMax & numel(S) > sMin;
    end
%%
    function [LOpt, ROpt, dOpt, tOpt] = findSplit(S)
        if random
            [LOpt, ROpt, dOpt, tOpt] = findSplitR(s);
        else
        Delta = -1;
        Delta = fix(Delta, S, L, R);
        end
    end
%%
    function p = distribution(S)
        p = double(zeros(numel(S.labelMap)));
        for i = 1:numel(S.labelMap)
            p(i) = sum(S.y == S.labelMap(i, 1)); 
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

    % Any other helper functions you may need go here
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