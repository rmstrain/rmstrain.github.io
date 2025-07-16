%%%%%%%%%%%%%%%%%%%%%% DoubleIntHW5.m %%%%%%%%%%%%%%%%%%%%%%

function Int=DoubleIntHW5

% DESCRIPTION: We are computing the iterated integral 
% int^1_0int^1_0 sin(x^3+y^3)dxdy using composite Simpson's 
% rule with 100 subintervals for x and y.  We will make use 
% of the subroutine below, FIntHW5. 

% INPUT: No input. 

% OUTPUT: Int is the approximate value of the double integral. 

% Initializing "sums" arising in composite Simpson's rule
S1=0;
S2=0;

% computing sums
for i=1:50
    
    S1=S1+FIntHW5((2*i-1)/100);
    
end

for i=1:49
    
    S2=S2+FIntHW5((2*i)/100);
    
end
    
% Composite Simpson's Rule with 100 subintervals

Int=(1/300)*(FIntHW5(0)+4*S1+2*S2+FIntHW5(1));



%------------- Subroutine: FIntHW5.m -------------%

function Integral=FIntHW5(y)

% DESCRIPTION: We are computing the function 
% F(y)=int^1_0 sin(x^3+y^3)dx using composite Simpson's 
% rule with 100 subintervals. 

% INPUT: y is a number between 0 and 1. 

% OUTPUT: Integral is the approximate value of F(y). 




% Integrand 
fun=@(x)sin(x^3+y^2);

% Initializing "sums"
s1=0;
s2=0;

% computing sums
for i=1:50
    
    s1=s1+fun((2*i-1)/100);
    
end

for i=1:49
    
    s2=s2+fun((2*i)/100);
    
end
    
% Composite Simpson's Rule with 100 subintervals

Integral=(1/300)*(fun(0)+4*s1+2*s2+fun(1));


% Compure the numerical results with
% integral2(@(x,y)sin(x.^3+y.^2),0,1,0,1).
    
