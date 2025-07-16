%%%%%%%%%%%%%%%%%%%%%%%%%%% NewtonBisection.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DESCRIPTION: This is a MATLAB implementation of the Newton-Bisection Method
% algorithm for finding roots of a twice differentiable function. 
% This particular implementation outputs the results of the iterates in a 
% table.  

% INPUT: f is the function handle of a differentiable function; df is the function
% handle of its derivative. [a,b] is an interval for which the function has
% a bracket. The method stops once MaxNum iterations have been done.

% OUTPUT: This method has no official output; it only prints the results of
% the algorithm.


function NewtonBisection(a,b,MaxNum,f,df)


% The heading of the table
fprintf(' k ----- xk ------- f(xk) ------ Step Type \n ');

left = a;
right = b;

for index=1:MaxNum

    % Newton step first!
    middle = left - f(left)/df(left);

    % Keep if c belongs to [a,b], else take midpoint
    if ((middle>left)&&(middle<right))
        % print statement at Newton Step
        fprintf('%d\t%f\t%f\t Newton \n ', index, middle,f(middle));
    else
        middle=(left+right)/2;
        % print statement at Bisection Step
        fprintf('%d\t%f\t%f\t Bisection \n ', index, middle,f(middle));
    end
    
    % Keeping our "Bracket"
    if f(middle)*f(right)<0
        left=middle;
    else
        right=middle;
    end
    
    
end
