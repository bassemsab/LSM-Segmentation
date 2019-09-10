function Kappa_H = Reg_Xie(phi);
%The level set regularization term for Xie's method
%Input:
% phi: level set function;
%Output:
%Kappa_H: reguralization term
%formulation: Kappa_H =div( H(|\Delta(\phi)|-1)\Delta(\phi))
%Author: Kaihua Zhang
%Email: cskhzhang@comp.polyu.edu.hk
%Date: 16/7/2010
[Kappa,absR] = Curvature_central(phi);
H = Heaviside(absR-1,1);
[nx,ny]=gradient(phi);
[nxx,junk]=gradient(H.*nx);  
[junk,nyy]=gradient(H.*ny);
Kappa_H=nxx+nyy;