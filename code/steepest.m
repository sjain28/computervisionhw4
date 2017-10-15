function [x, allx] = steepest(Grad, x, maxits, deltax)
    
    %vecsize = size(x);
    %allx = double(zeros(maxits, vecsize(1)));
    allx(1,:) = x;
    
    for i = 2:maxits
        
        gradient = Grad(x);
        if ~any(gradient)  
            break
        end
        
        if norm(x-allx(i-1)) < deltax
            break
        end
        
        x = linesearch(Grad, x, -gradient);
        
        %Might need to take x' depending on format of linesearch return
        allx(i, :) = x;
        
    end
    
    %Remove leading 0's incase the for loop breaks early
    allx = allx(any(allx,2),:)';
end
