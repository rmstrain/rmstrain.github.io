%%%%%%%%%%%%%%%%% ImpliedVol.m %%%%%%%%%%%%%%%%%

% DESCRIPTION: ImpliedVol finds the Implied Volatility of 
% Black-Scholes formula using Newton's Method.

% INPUT:Sig0 is the guess, xx the stock price, kk the strike,
% tt maturtiy, rr rate, CC market call price, Tol is the error 
% tolerance for Newton's method, and MaxSteps is the Maximum 
% number of steps. 

% OUTPUT: Sigma, which is a numerical approximation of the 
% implied volatility. 


function Sigma=ImpliedVol(Sig0,xx,kk,tt,rr,CC,Tol,MaxSteps)

% Black-Scholes formula as a funtion of sigma minus market call price. 
bsmMinusC=@(sigma) BSM(xx,kk,tt,rr,sigma)-CC; 

% formula for partial derivative with respect to simga
dplus=@(sigma)(log(xx/kk)+(rr+.5*sigma^2)*tt)/(sigma*sqrt(tt));

vega=@(sigma) xx*sqrt(tt)*exp(-.5*(dplus(sigma))^2)/sqrt(2*pi);

% Sigma computed with Newton's method below.  
Sigma=Newton(Sig0,bsmMinusC,vega,Tol,MaxSteps);


%------------------------------------------------------------------



%%%%%%%%%%%%%%%%% Subroutine "Newton" %%%%%%%%%%%%%%%%%

% DESCRIPTION: This is a MATLAB implementation of the Newton's Method
% algorithm for finding roots of a differentiable function.

% INPUT: f is the function handle of a differentiable function. x0 is the 
% initial guess. Tol>0 is the error tolerance; the method stops once 
% |f(root)|<Tol. MaxNum is the maximum number of iterations the method will
% run, even it the tolerance criterion isn't met. 

% OUTPUT: root is the approximation to a solution of f(x)=0.
function root=Newton(x0,f,df,tol,MaxNum)

Counter=0;

% While f isn't within the tol and not too many steps have been taken
while ( (abs(f(x0))>tol) && (Counter<MaxNum) )
   
    % Newton's step
    x1 = x0 - f(x0)/df(x0);
    x0 = x1;
    
    % Keeping count
    Counter = Counter+1;
        
end

% output final iterate
root=x0;
    