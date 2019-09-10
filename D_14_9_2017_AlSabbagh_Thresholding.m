clear all;
close all;

Img =imread(imgetfile);

%get segmentation target
T = graythresh(Img);
m= imbinarize (Img,T);

gt=logical(imread(imgetfile));

gt=logical(gt*2);

% figure
% imshow(gt)
% figure
% imshow(m)
itsc=minus(gt,m);


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

disp([p,r,F]);

figure;
subplot(1,2,1);
imshow(Img);
subplot(1,2,2);
imshow(m);