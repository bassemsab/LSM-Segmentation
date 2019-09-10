function [phi,F] = CV_2D(I, phi, mu,nu,lambda_1, lambda_2, timestep, epsilon,flag,delt2)
%This function updates the level set function according to the CV model 
% Input:
% I:tested image; phi: level set function;
% mu: constant, in most cases, m == 0; nu: coefficient for curvature term; 
%lambda_1 == lambda_2 == 1; 
%timestep: time step for level set evolution function; 
%flag: 'RD': RD method; 'LIM':Li'method [9];'ILIM': Li's method[59]; 'XIE':Xie's method;
%'LSR': re-initialization method;'LSW': direct implementation without re-initialization
% delt2: time step for our RD regularization 
%Output:
%phi: level set function after one iteration
%F: the force term
%Author: Kaihua Zhang
%Email: cskhzhang@comp.polyu.edu.hk
%Date: 16/7/2010

    diracPhi=Delta(phi,epsilon);
    Hphi=Heaviside(phi, epsilon);
    %----------------------------
    [Kappa,absR] = Curvature_central(phi);
    
    switch flag %'RD': RD method; 'LIM':Li et al.,'s method; 'XIE':Xie's method; 'LSR': re-initialization method;'LSW': direct implementation without re-initialization
        case  'RD'
        [C1,C2]=binaryfit(I,Hphi); 
        phi=phi+timestep*(diracPhi.*(mu+nu*Kappa-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2));
        phi = phi + delt2*4*del2(phi);
        case 'GDRLSE1'
        [C1,C2]=binaryfit(I,Hphi); 
        phi=phi+timestep*(0.2*(4*del2(phi)-Kappa)+diracPhi.*(mu+nu*Kappa-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2));
        case 'GDRLSE3'
        Kappa_H = Reg_Xie(phi);
        [C1,C2]=binaryfit(I,Hphi);
        phi=phi+timestep*(0.2*Kappa_H+diracPhi.*(-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2));
        case 'LSR'
        [C1,C2]=binaryfit(I,Hphi);
        phi=phi+timestep*(diracPhi.*(mu+nu*Kappa-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2));
        dx=1;dy=1;alpha=0.5;iterations=10;
        phi = reinit_SD(phi, dx, dy, alpha, iterations);
        case 'LSW'
        [C1,C2]=binaryfit(I,Hphi);
        phi=phi+timestep*(diracPhi.*(mu+nu*Kappa-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2));
        case 'GDRLSE2'
        [C1,C2]=binaryfit(I,Hphi); 
        r = RegularizeF(phi);
        phi=phi+timestep*(0.2*r+diracPhi.*(mu+nu*Kappa-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2));
    end
    
    F = (-lambda_1*(I-C1).^2+lambda_2*(I-C2).^2);
    
function H = Heaviside(phi,epsilon) 
H = 0.5*(1+ (2/pi)*atan(phi./epsilon));

function Delta_h = Delta(phi, epsilon)
Delta_h=(epsilon/pi)./(epsilon^2+ phi.^2);

function [C1,C2] = binaryfit(I,Hphi)
C1 = sum(sum(I.*Hphi))/(sum(sum(Hphi)));
C2 = sum(sum(I.*(1-Hphi)))/(sum(sum((1-Hphi))));
