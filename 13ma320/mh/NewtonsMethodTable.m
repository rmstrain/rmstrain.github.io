%%%%%%%%%%%%%%%%%%%%%%%%%%% NewtonsMethodTable.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DESCRIPTION: This is a MATLAB implementation of the Newton's Method
% algorithm for finding roots of a differentiable function. This particular
% implementation outputs the results of the iterates in a table. 

% INPUT: f is the function handle of a differentiable function; df is the function
% handle of its derivative. x0 is the initial guess. The method stops once 
% MaxNum iterations have been done.

% OUTPUT: This method has no official output; it only prints the results of
% the algorithm.


function NewtonsMethodTable(x0,MaxNum,f,df)

Counter=0;

% The heading of the table
fprintf(' k ---------------- xk ------------------- f(xk)\n ');

% The method runs "While" MaxNum steps have not been taken
while (Counter<MaxNum)
   
    % Newton's step
    x1 = x0 - f(x0)/df(x0);
    x0 = x1;
    
    % Keeping count
    Counter = Counter+1;
    
    % print statement at each step
    fprintf('%d \t\t %f \t \t %f\n ',Counter, x1,f(x1));
    
end
