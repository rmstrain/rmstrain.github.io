%%%%%%%%%%%%%%%%%%% Fibonacci1 %%%%%%%%%%%%%%%%%%

% DESCRIPTION: Fibonacci1 computes the Nth Fibonacci number by using the
% recurrence relation: Fn+1=Fn+Fn-1.

% INPUT: Num is a positive integer bigger or equation to 2. 

% OUTPUT: FibNum, the "Num"th Fibonacci number. 

function FibNum=Fibonacci1(Num)


Fnminus1=0;

Fn=1;

for index=1:Num-1
    
    % Fibonacci recurrence
    Fnplus1=Fn+Fnminus1;
    
    % Updating Fn and Fn-1 so we don't have to store them
    Fnminus1=Fn;
    Fn=Fnplus1;
    
end

FibNum=Fnplus1; 

% Question: How can we augment this program to accept input of 0 or 1? 