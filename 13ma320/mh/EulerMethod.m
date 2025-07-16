%%%%%%%%%%%%%%%%%%%% Euler's Method %%%%%%%%%%%%%%%%%%%%%%%%

function EulerMethod(fun,y0,T,h)

% DECRIPTION: Euler's method for solving the ODE y'=fun(t,y), y(0)=y0 on
% the interval [0,T].

% INPUT: fun inline function for the ODE; y0 initial condition; T is the
% length of the interval that we are seeking a solution; and h is the step
% size. Note: fun is assumed to be a function of (t,y). 

% OUTPUT: We graph the approximate solution versus time.



% The number of steps to be taken with the method
Numsteps=floor(T/h);

% initialize the approximate solution y
y=zeros(Numsteps+1,1);

% initialize the time vector 0,h,2*h,..., h*N ? T
t=linspace(0,h*Numsteps,Numsteps+1);

% Initial condition. Note can't "set" y(0) in MATLAB
y(1)=y0;

% Euler's method
for i=1:Numsteps
    % Euler's step
    y(i+1)=y(i)+h*fun(t(i),y(i));
end

% Plot the approximate solution versus time
plot(t,y)

% -----------------------------------------------------------------
% Example: EulerMethod(@(t,y)y,1,5,10^(-3))
% Question: How can we tailor this program to solve systems of ODE?

