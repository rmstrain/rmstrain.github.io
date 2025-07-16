%%%%%%%%%%%%%%%%%%% Fibonacci2 %%%%%%%%%%%%%%%%%%

% DESCRIPTION: Fibonacci1 computes the Nth Fibonacci number by using the
% analytic formula.

% INPUT: Num is a positive integer bigger or equation to 2. 

% OUTPUT: FibNum, the "Num"th Fibonacci number. 

function FibNum=Fibonacci2(Num)

phi1=(1+sqrt(5))/2;

phi2=(1-sqrt(5))/2;


FibNum=(1/sqrt(5))*((phi1)^Num - (phi2)^Num ); 

