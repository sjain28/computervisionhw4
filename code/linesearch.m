function x = linesearch(Grad,x0,p)

% check that function decreases along search direction
step = Grad(x0)' * p;
if step  > 0
  error('p is not a direction of decrease. Check your gradient definition')
elseif step == 0
    x = x0;
    return;
end

% find bracketing interval
a = 1e-4;
while Grad(x0 + p * a)' * p < 0
  a = 1.6 * a;
end

% use Matlab toolbox to find point of zero directional derivative
options = optimset('TolX', 1e-6);
a = fzero(@line, [0 a], options, Grad, x0, p);
x = x0 + a*p;

    function y = line(a, Grad, x0, p)
        y = - Grad(x0 + a * p)' * p;
    end

end