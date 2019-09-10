function phi = CV_3D(I,phi,mu,alpha,lambda1,lambda2,delt,epsilon)
%This function updates the 3D level set function according to the CV model 
%Input:
%I:tested image; 
% phi: level set function;
%mu: coefficient for curvature term; 
%alpha: constant, in most cases, alpha == 0;
%lambda1 == lambda2 == 1; 
%delt: time step for level set evolution function; 
%Output:
%phi: level set function after one iteration
%Author: Kaihua Zhang
%Email: cskhzhang@comp.polyu.edu.hk
%Date: 16/7/2010

H = Heaviside(phi,epsilon);
DiracH = Delta(phi,epsilon);

Kappa = curvature_3d(phi);
c1 = sum(sum(sum(I.*H)))./sum(sum(sum(H)));
c2 = sum(sum(sum(I.*(1-H))))./sum(sum(sum(1-H)));
phi = phi + delt*(mu*Kappa-alpha-lambda1*(I-c1).^2+lambda2*(I-c2).^2).*DiracH;





