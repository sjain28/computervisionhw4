
errors = double(zeros(20, 1));

for i = 1:20
    tau = trainTree(T, 0, false, i);
    errors(i) = err(@(x) treeClassify(x, tau), V);
end

[minError, depth] = min(errors)