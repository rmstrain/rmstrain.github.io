%%%%%%%%%%%%%%%%%%%%%%% BestOmega.m %%%%%%%%%%%%%%%%%%%%%%%

% DESCRIPTION: This program computes the optimal omega in the
% variant of Jacobi-Iteration that we are considering in problem
% 3 of HW 4. 

% INPUT: A square matrix A with real coefficients 

% OUTPUT: The omega such that the coefficient matrix arising in the
% variant of Jacobi-Iteration has the smallest spectral radius. We 
% only search over omega=.01, .02, ... , 1.98, 1.99. 

function Opt=BestOmega(A)

% Lower triangular part of A
L=tril(A,-1);

% Diagonal of A
D=diag(diag(A));

% Upper triangular part of A
U=A-L-D;

% All the omegas that we will consider
OVec=.01:.01:1.99;

% Length of this vector (to be used in a for loop below)
OmegaLen=length(OVec);

% Take the first Omega (.01) as a candidate for the optimal Omega
Opt=OVec(1);

% Compute the first candidate
rOld=max(abs(eig((D+Opt*L)\((1-Opt)*D - Opt*U))));

for index=2:OmegaLen
    
    % Compute the new competitor
    rNew=max(abs(eig((D+OVec(index)*L)\((1-OVec(index))*D - OVec(index)*U))));

    if (rNew<= rOld)
        Opt=OVec(index);
    end
    
    % Usual iteration scheme so we don't have to save values as we go
    rOld=rNew;
end


