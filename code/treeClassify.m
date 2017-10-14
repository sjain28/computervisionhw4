function y = treeClassify(x, tau)

while ~isempty(tau.d)
    val = x(tau.d);
    if val <= tau.t
        tau = tau.L;
    else
        tau = tau.R;
    end
end

[~,I] = max(tau.p);
y = I(1);

end