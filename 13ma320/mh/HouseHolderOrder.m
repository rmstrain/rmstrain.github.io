%%%%%%%%%%%%%%%%%%%%%%%%%%% HouseHolderOrder.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DESCRIPTION: This is a MATLAB implementation of the HouseHolder's
% algorithm for finding roots of a twice differentiable function.

% INPUT: f is the function handle of a twice differentiable function. x0
% is the initial guess. This method will run for MaxNum iterations and will
% plot the (approximate) absolute relative errors in log scale. 

% OUTPUT: Order is the approximate order that the scheme converges in.


function Order=HouseHolderOrder(x0,MaxNum,f,df,ddf)

% Initializing a vector to place the iterates of HouseHolder's Method
xVec=zeros(MaxNum+1);

xVec(1)=x0;

% While f(x) isn't within the tol and not too many steps have been taken
for i=1:MaxNum   
    % Newton's step
    xVec(i+1) = xVec(i) - (f(xVec(i))/df(xVec(i)))*(1 + ...
        .5*(f(xVec(i))*ddf(xVec(i)))/(df(xVec(i))^2));
        
end

% Vector of Errors: 
ErrorVec=abs(diff(xVec));
%length of ErrorVec
len=length(ErrorVec);

% Making the loglog plot
loglog(ErrorVec(1:len-1),ErrorVec(2:len))


% Crude approximation of the order (just the slope)
Order=log(ErrorVec(3)/ErrorVec(2))/log(ErrorVec(2)/ErrorVec(1)); 
