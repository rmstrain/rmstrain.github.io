%%%%%%%%%%%%%%%%%%%%%%%%%%% NewtonsMethod.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DESCRIPTION: This is a MATLAB implementation of the Newton's Method
% algorithm for finding roots of a differentiable function.

% INPUT: f is the function handle of a differentiable function. x0 is the 
% initial guess. Tol>0 is the error tolerance; the method stops once 
% |f(root)|<Tol. MaxNum is the maximum number of iterations the method will
% run, even it the tolerance criterion isn't met. 

% OUTPUT: root is the approximation to a solution of f(x)=0.


function root=NewtonsMethod(x0,Tol,MaxNum,f,df)

Counter=0;

% While f isn't within the tol and not too many steps have been taken
while ( (abs(f(x0))>Tol) && (Counter<MaxNum) )
   
    % Newton's step
    x1 = x0 - f(x0)/df(x0);
    x0 = x1;
    
    % Keeping count
    Counter = Counter+1;
        
end

% output final iterate
root=x0;
    

% Q: How can we write this program without having to enter the derivative
% of f? i.e. can MATLAB compute this for us?
% Q: Write this code with another type of loop?
% Q: How can we output/indicate whether or not the toleratnce criterion was met?