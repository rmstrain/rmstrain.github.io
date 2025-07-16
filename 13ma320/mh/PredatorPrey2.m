%%%%%%%%%%%%%%%%%%%% PredatorPrey2.m %%%%%%%%%%%%%%%%%%%%%%%%

function PredatorPrey2(a,b,c,d,T,x0,y0,h)

% DECRIPTION: Classical fourth order Runge-Kutta method is used to solve
% the Predator Prey system x'=(a-by)x, y'=(-c+dx)y, x(0)=x0, y(0)=y0 on 
% the interval [0,T].  

% INPUT: a,b,c,d are parameters associated with the model (positive 
% numbers); x0, y0 initial conditions; T is the length of the interval that
% we are seeking a solution; and h is the step size. 

% OUTPUT: We graph the approximate solutions versus time and also graph
% both solutions together in the xy plane. 

% NOTE: below we will change notation to x=x(1) and y=x(2) and study the
% system as a single vector ODE.


% The ODE function arising in the Predator Prey model
PPfun=@(t,x)[(a-b*x(2))*x(1), (-c+d*x(1))*x(2)];

% The number of steps to be taken with the method
Numsteps=floor(T/h);

% initialize the approximate solution x
x=zeros(Numsteps+1,2);

% initialize the time vector 0,h,2*h,..., h*N ? T
t=linspace(0,h*Numsteps,Numsteps+1);

% initial condition
x(1,:)=[x0, y0];

% RK4 method
for i=1:Numsteps
    % RK4 set-up 
    g1=PPfun(t(i),x(i,:));
    g2=PPfun(t(i)+h/2,x(i,:)+(h/2)*g1);
    g3=PPfun(t(i)+h/2,x(i,:)+(h/2)*g2);
    g4=PPfun(t(i)+h,x(i,:)+h*g3); 
    
    % RK4 step
    x(i+1,:)=x(i,:)+h*((1/6)*g1 +(1/3)*g2+(1/3)*g3+(1/6)*g4);
end

% Plot the approximate solutions versus time
figure(1)
plot(t,x(:,1),t,x(:,2))

% Phase plane plot of (x1,x2)
figure(2)
plot(x(:,1),x(:,2))


% Run the commands below to compare with your own solutions
% -------------------------------------------------------------------
% PredatorPrey2(.04,.005,.2,.1,87,1,1,.001)
% PredatorPrey2(.4,.1,.5,1,54,3,1,.001)
% PredatorPrey2(.2,1,.5,1,100,1,2,.001)
% PredatorPrey2(.1,.5,1,.2,89,1,2,.001)
