function g = rosengrad(x)
    x1 = double(x(1));
    x2 = double(x(2));
    
    g1 = -400*x1*x2 + 400*(x1^3) + 2*x1 - 2;
    g2 = 200*x2 - 200*(x1^2);
    
    g = [g1, g2]';
    
end
