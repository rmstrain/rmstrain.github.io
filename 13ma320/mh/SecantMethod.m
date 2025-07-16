%%%%%%%%%%%%%%%%%%%%%%%%%%% SecantMethod.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DESCRIPTION: This is a MATLAB implementation of the Secant Method
% algorithm for finding roots of a continuous function.

% INPUT: f is the function handle of a continuous function. x0 and x1 are  
% initial guesses. Tol>0 is the error tolerance; the method stops once 
% |f(root)|<Tol. MaxNum is the maximum number of iterations the method will
% run, even it the tolerance criterion isn't met. 

% OUTPUT: root is the approximation to a solution of f(x)=0.


function [root, NumIter]=SecantMethod(x0,x1,Tol,MaxNum,f)

Counter=0;

% While f isn't within the tol and not too many steps have been taken
while ( (abs(f(x1))>Tol) && (Counter<MaxNum) )
   
    % Secant step
    x2 = x1 - f(x1)*(x1-x0)/(f(x1)-f(x0));
    
    % Updating dummy variables for the next step
    x0 = x1;
    x1 = x2;
    
    % Keeping count
    Counter = Counter+1;
        
end

% output the last iterate
root=x1;
% output the number of iterates
NumIter=Counter;    