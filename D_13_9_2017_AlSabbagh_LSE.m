clear all;
close all;

%get segmentation target
Img=imread(imgetfile);
gt=logical(imread(imgetfile));
%gt=gt(:,:,1);
%get ground truth image
% Img=imread('330bb022.bmp');
% ImGT=imread('330bb022_GT.bmp');
BW=im2bw(Img,0.8);
BW=double (BW);

Img=double(Img(:,:,1));

% figure(1);
% subplot(1,2,1), imshow (uint8(Img)),title('Grayscale subject');
% subplot(1,2,2), imshow (BW),title ('Binary Subject');
 

%% parameter setting
timestep=5;  % time step
mu=0.2/timestep;  % coefficient of the distance regularization term R(phi)
iter_inner=5;
iter_outer=5;
lambda=5; % coefficient of the weighted length term L(phi)
alfa=1.5;  % coefficient of the weighted area term A(phi)
epsilon=1.5; % papramater that specifies the width of the DiracDelta function


%This looks like something that will lead to gradient alignment ?
sigma=1.5;     % scale parameter in Gaussian kernel
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(Img,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth); %get curvature
f=Ix.^2+Iy.^2; %get MSB of curvature
g=1./(1+f);  % edge indicator function.

%-----------------------Set the intialization of LSF by yourself
figure;  imagesc(Img,[0 255]);colormap(gray);
text(10,10,'Left click to get points, right click to get end point','FontSize',[10],'Color', 'r');
BW = roipoly;
phi =  4*(0.5-BW);
figure;
imshow(phi);

% initialize LSF as binary step function
% phi = BW * -4 ;
% phi = phi+2;
% phi(10:end-10,10:end-10)= -2;
% phi(end-20:end,end-20:end)= -2;
% figure;
% imshow(phi);
%c0=2;
%initialLSF=c0*ones(size(Img));
% generate the initial region R0 as a rectangle
%initialLSF(10:55, 10:75)=-c0;  
%phi=initialLSF;

figure(2);
subplot(1,2,1);
mesh(-phi);   % for a better view, the LSF is displayed upside down
hold on;  
contour(phi, [0,0], 'r','LineWidth',2);
title('Initial level set function');
%view([-80 35]);

figure(2);
subplot (1,2,2);
imagesc(Img,[0, 255]); axis off; axis equal; hold on;  contour(phi, [0,0], 'r');
title('Initial zero level contour');
%pause(1);


potential=2;  
if potential ==1
    potentialFunction = 'single-well';  % use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model 
elseif potential == 2
    potentialFunction = 'double-well';  % use double-well potential in Eq. (16), which is good for both edge and region based models
else
    potentialFunction = 'double-well';  % default choice of potential function
end


% start level set evolution
for n=1:iter_outer
   
    phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction);
     figure(3);
     subplot(1,2,2);
     imagesc(Img,[0, 255]); axis off; axis equal;hold on;
     contour(phi, [0,0], 'r');
     iterNum = [num2str(n*iter_inner), ' Iteration(s)'];
     title(iterNum);
     pause(0.02);
end

% refine the zero level contour by further level set evolution with alfa=0
alfa=0;
iter_refine = 10;
phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction);


finalLSF=phi;
figure(4);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
hold on;  contour(phi, [0,0], 'r');
str=['Final zero level contour, ', num2str(iter_outer*iter_inner+iter_refine), ' iterations'];
title(str);

%Extract image mask(foreground)from LSF
m=logical(finalLSF-2);

%Number of non-zero elements in final LSF
m_sz=nnz(m);
finalLSF_fg_sz=nnz(finalLSF>0);
%figure;
%imshow(finalLSF);
%figure;
%imshow(m);

figure(3);
subplot(1,2,1);
mesh(-finalLSF); % for a better view, the LSF is displayed upside down
hold on;  contour(phi, [0,0], 'r','LineWidth',2);
str=['Final level set function, ', num2str(iter_outer*iter_inner+iter_refine), ' iterations'];
title(str);
axis on;


%Performance evaluation
gt=gt*2;
itsc=gt-m;
%0
tn=size(find(itsc==0));
%-1
fp=size(find(itsc==-1));
%2
fn=size(find(itsc==2));
%1
tp=size(find(itsc==1));
p=tp/(tp+fp);
r= tp/(tp+fn);
F=2*((p*r)/(p+r));
