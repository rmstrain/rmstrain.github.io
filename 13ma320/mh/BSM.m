%%%%%%%%%%%%%%%%% BSM.m %%%%%%%%%%%%%%%%%

% DESCRIPTION: BSM evaluates the Black-Scholes formula
% for a European call option. 

% INPUT: xx, sig can be vectors (the other should be a scalar), 
% kk, tt, rr are scalars. Each entry or parameter must be positive. 

% OUTPUT: The Black-Scholes evaluated on the input. This 
% will be a vector or scalar depending on the inputs of xx and sig. 

function Call=BSM(xx,kk,tt,rr,sig)

% Complicated arguments of the normal distribution function
dplus=(log(xx./kk)+(rr+.5*sig.^2)*tt)./(sig*sqrt(tt));
dminus=dplus - sig*sqrt(tt);

% Using the formula Phi(x)=.5*(1+erf(x/sqrt(2)))
Phiplus=.5*(1+erf(dplus./sqrt(2)));
Phiminus=.5*(1+erf(dminus./sqrt(2)));

% BSM formula
Call=xx.*Phiplus - kk*exp(-rr*tt)*Phiminus;