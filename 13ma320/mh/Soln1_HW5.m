% Solution #1 HW5

% ----------------------- PART (a) ------------------------ %

% Runges function
Runge=@(x)1./(1+25*x.^2);

% Interpolating on 10 equally spaced points
x10=-1+(2/10)*(0:10);
y10=Runge(x10);
p10=polyfit(x10,y10,10);

% Interpolating on 20 equally spaced points
x20=-1+(2/20)*(0:20);
y20=Runge(x20);
p20=polyfit(x20,y20,20);

% Interpolating on 30 equally spaced points
x30=-1+(2/30)*(0:30);
y30=Runge(x30);
p30=polyfit(x30,y30,30);

% many points between -1 and 1 to evaluate our polynomials
xvar=-1:.001:1;

% Plotting Polynomials together
plot(xvar,Runge(xvar),xvar,polyval(p10,xvar), ... 
    xvar,polyval(p20,xvar),xvar,polyval(p30,xvar))

% making a legeng with MATLAB
legend('Runge''s function','p10','p20','p30')

% ----------------------- PART (c) ------------------------ %

% Computing the "max" error
max(abs(Runge(xvar)-polyval(p10,xvar)))
max(abs(Runge(xvar)-polyval(p20,xvar)))
max(abs(Runge(xvar)-polyval(p30,xvar)))