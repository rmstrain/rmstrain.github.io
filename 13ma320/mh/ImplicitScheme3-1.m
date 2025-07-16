%%%%%%%%%%%%%%%%%%%%%%%%%% ImplicitScheme3.m %%%%%%%%%%%%%%%%%%%%%%%%%%

function ImplicitScheme3(u0,T,M,N)

% DESCRIPTION: This is an implementation of the implicit scheme for the 
% standard heat equation on the "strip" 0<x<1, 0<t<T.

% INPUT: u0 is an inline function representing the initial condition;
% T is the time up to which we are solving the equation; M in the number 
% of time sub-intervals used in the finite difference scheme; and 
% N is the number of space sub-intervals. 

% OUTPUT: A graph of the solution at time T. 

% delta t
h=T/M;


% delta x
k=1/N;


% alpha
alpha=h/(k^2);


% Intialize u matrix: u(i,j) approximates the true solution u(ti,xj), 
% where ti=i*h, i=0,...,M and xj=j*k, j=0,...,N
u=zeros(M+1,N+1);

% Note: boundary conditions u(t,0)=u(t,1)=0 are automatically satisfied

% Initial Condition
x=0:k:1;
u(1,:)=u0(x);


% Explicit Scheme
for i=1:M
       
    % Use tridiagonal solver
    u(i+1,2:N)=HeatTriDiag(alpha,u(i,2:N));
 
end

% Plotting the "final" curve
plot(x,u(M+1,:));
xlabel('x')
ylabel('u(T,x)')


% ------------------------- HW responses ------------------------
% ImplicitScheme3(@(x)50*(x.^2-x.^4),.5,200,100) 
% ImplicitScheme3(@(x)100*(-x.^2+x.^7).*sin(3*pi*x),.1,400,100) 
% ImplicitScheme3(@(x)1000.*(exp(x)-1).*sin(5*pi*x),.025,200,100)

