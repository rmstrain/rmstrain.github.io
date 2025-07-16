%%%%%%%%%%%%%%%%%%%%%%%%%% HeatTriDiag.m %%%%%%%%%%%%%%%%%%%%%%%%%%

function soln=HeatTriDiag(alpha,Target)

% DESCRIPTION: This is an implementation of the tridiagonal solver 
% detailed in the book on page 211. Note that we use the entries of
% the tridiagonal matrix associated with the implicit scheme for the 
% standard heat equation. 

% INPUT: alpha is any positive number; Target is a vector "b" to be 
% solve for in the equation "Tx=b" where T is tridiagonal with 
% diagonal entries 1+2alpha and off diagonal entries -alpha. 

% OUTPUT: soln, the solution of "Tx=b."

% Dimension of the matrix
N=length(Target);

% Initializing paramters to be used in the tridiagonal solver
w=zeros(N,1);
rho=zeros(N,1);
zeta=zeros(N,1);
soln=zeros(N,1);

% t=s=-alpha, d=1+2alpha
w(1)=1+2*alpha;
rho(1)=(-alpha)/w(1);
zeta(1)=Target(1)/w(1);

% Textbook algorithm on page 211 
for i=2:N
    
    w(i)=1+2*alpha-(-alpha)*rho(i-1);
    rho(i)=(-alpha)/w(i);
    zeta(i)=(Target(i)-(-alpha)*zeta(i-1))/w(i);
end

soln(N)=zeta(N);
for k=N-1:-1:1
    soln(k)=zeta(k)-rho(k)*soln(k+1);
end
