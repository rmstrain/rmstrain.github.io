%%%%%%%%%%%%%%%%%%%%%%%%%%% bisection.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DESCRIPTION: This is a MATLAB implementation of the bisection algorithm
% for finding roots of a continuous function.

% INPUT: f is the function handle of a continuous function defined on the
% interval [a,b] and satisfying f(a)f(b)<0. So a and b are real numbers
% with a<b. Tol>0 is the error tolerance; the method stops once 
% |f(root)|<Tol. 

% OUTPUT: root is the approximation to a solution of f(x)=0.


function root=bisection(a,b,Tol,f)


% Return error message if f does not satisfy f(a)*f(b)<0
if f(a)*f(b)>=0
    fprintf('Error: f(a)*f(b)>=0 \n');
else
    
    % new variables for the bisection process
    left=a;
    right=b;
    middle=(left+right)/2;
    
    
    % Run the algorithm while |f(middle)|>Tol
    while (abs(f(middle))>Tol)
        
       if f(left)*f(middle)<0
           right=middle;
       else
           left=middle;
       end
        
       middle=(left+right)/2;
        
    end

    % output final iterate
    root=middle;
    
end


% Q: Write this code with another type of loop?
% Q: What are other stopping criterion? 
% Q: How can we keep track of the number of iterates the current program
% uses on a given execution?