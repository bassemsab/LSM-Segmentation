function Delta_h = Delta(phi,epsilon,f)
if nargin < 3 
Delta_h = (epsilon/pi)./(epsilon^2+phi.^2);% Dirac functional 2
else
Delta_h=(1/2/epsilon)*(1+cos(pi*phi/epsilon));
b = (phi<=epsilon) & (phi>=-epsilon);
Delta_h = Delta_h.*b; % Dirac functional 1
end