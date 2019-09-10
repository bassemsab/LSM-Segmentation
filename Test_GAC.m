%%%%Test GAC model
% 
% Author: Kaihua Zhang
% Email: cskhzhang@comp.polyu.edu.hk
% Date:  15/7/2010

clc;clear all;close all;
%---------------
Img = imread('330bb023.bmp');%Your can choose your own image

Img = double(Img(:,:,1));
[nrow,ncol]=size(Img);
%-----------------------------Default Parameter Setting
delt = .1;% timestep for level set evolution equation;
delt2 = 0.001; % timestep for diffusion regularization equation; 
v =.9;% constant force: the value should be from 0 to 1.
Iternum = 100;% iteration number
%--------------------------------------------------------------------------
%-----------------------------For GAC model, compute edge-stopping function
sigma=1.5;    % scale parameter in Gaussian kernel for smoothing. 1.5, twocells.0.45,synthetic image
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(Img,G,'same');  % smooth image by Gaussian convolution

[Ix,Iy]=gradient(Img_smooth);
% Img = Img_smooth;
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.

%-----------------------Set the intialization of LSF by yourself
figure;  imagesc(Img,[0 255]);colormap(gray);
text(10,10,'Left click to get points, right click to get end point','FontSize',[10],'Color', 'r');
BW = roipoly;
phi =  2*(0.5-BW);

for n=0:Iternum
    strcat(num2str(n), 'iterations')
    phi = NeumannBoundCond(phi);
    [Kappa,absR] = Curvature_central(phi);
    %---------
    [nx,ny]=gradient(phi);
    absR = sqrt(nx.^2+ny.^2);
    absR = absR +(absR==0)*eps;
    [nxx,junk]=gradient(g.*nx./absR);  
    [junk,nyy]=gradient(g.*ny./absR);
    Kappa_g=nxx+nyy;
    %--------------------------------------RD Level set evolution
    phi = phi + delt*((Kappa_g + g.*v).*absR);
    phi = phi + delt2*4*del2(phi);
   %---------------------------------------     
   if mod(n,10)==0
       imagesc(Img);colormap(gray);hold on;contour(phi,[0 0],'b','LineWidth',1);
       iterNum=[num2str(n), ' iterations'];title(iterNum);pause(.01);hold off;
   end
end
figure;mesh(phi);
title('Final level set function');