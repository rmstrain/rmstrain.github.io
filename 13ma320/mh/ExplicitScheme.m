function ExplicitScheme(u0,T,M,N,Frames)

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


% Plot initial condition
myfig=plot(x,u(1,:));


% Setting the axis of the figure
axis([0 1 min(u0(x)) max(u0(x))])


% Explicit Scheme
for i=1:M
    
    
    for j=2:N
        
        u(i+1,j)=alpha*u(i,j+1)+(1-2*alpha)*u(i,j)+alpha*u(i,j-1);
        
    end
    
    
    % Update the figure every "Frames" iterates
    if (mod(i,Frames)==0) 
         pause(.001)
         set(myfig,'YData', u(i+1,:))
    end
 
    
end

% ExplicitScheme(@(x)100*(-x.^2+x.^7).*sin(3*pi*x),.1,10000,100,25)
