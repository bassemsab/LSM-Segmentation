%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %This Program Compares Edge Detection methods ( Canny and Sobel) using Ground Truth of images( BSD images and Ground Truth). 
% Comparison is done using two parameters (PR and F-Measure), Higher the values of evaluation parameters, reflects better Edge Output.
% In Ideal Case(Evaluated for ground truth) Maximum value of PR is infinity and F-measure is 1. 
% 1. Select image Folder 
% 2. Select Ground Truth Folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;

%fp = mfilename('fullpath');
images = imgetfile;
fnames=dir(images);
f=filesep;

groundtruth= uigetdir('F:\groundtruth...','Select GroundTruth Folder');
names=dir(groundtruth);

A={'.jpg','.bmp','.png','.tif'};

tic;


for k = 1:length(fnames)
[pathstr,name,ext] = fileparts(fnames(k).name);
    if strcmpi(ext,'.jpg')==1;
    rgb=imread([images,filesep,...
    fnames(k).name]);
        if(size(rgb,3) > 1)
             f=rgb2gray(rgb); 
        else
             f=rgb;
        end
    sprintf('%d',k)
    t1=imread([groundtruth,filesep,...
    names(k).name]);
    sprintf('%d',k)   
c=edge(f,'canny',0.3);
b=edge(f,'sobel',0.1);


%% Precision and Recall for Canny
idx = (t1()==1);
pc = length(t1(idx));
nc = length(t1(~idx));
Nc = pc+nc;

tpc = sum(t1(idx)==c(idx));
tnc = sum(t1(~idx)==c(~idx));
fpc = nc-tnc;
fnc = pc-tpc;

tp_ratec = tpc/pc;
tn_ratec = tnc/nc;

accuracyc = (tpc+tnc)/Nc;
sensitivityc = tp_ratec;
specificityc = tn_ratec;
precisionc = tpc/(tpc+fpc);
recallc = sensitivityc;
f_measurec = 2*((precisionc*recallc)/(precisionc + recallc));
gmeanc = sqrt(tp_ratec*tn_ratec);

%% Precision and Recall for Ground Truth
idx = (t1()==1);
pt = length(t1(idx));
nt = length(t1(~idx));
Nt = pt+nt;

tpt = sum(t1(idx)==t1(idx));
tnt = sum(t1(~idx)==t1(~idx));
fpt = nt-tnt;
fnt = pt-tpt;

tp_ratet = tpt/pt;
tn_ratet = tnt/nt;

accuracyt = (tpt+tnt)/Nt;
sensitivityt = tp_ratet;
specificityt = tn_ratet;
precisiont = tpt/(tpt+fpt);
recallt = sensitivityt;
f_measuret = 2*((precisiont*recallt)/(precisiont + recallt));
gmeant = sqrt(tp_ratet*tn_ratet);

%% Precision and Recall for Sobel
idx = (t1()==1);
pb = length(t1(idx));
nb = length(t1(~idx));
Nb = pb+nb;

tpb = sum(t1(idx)==b(idx));
tnb = sum(t1(~idx)==b(~idx));
fpb = nb-tnb;
fnb = pb-tpb;

tp_rateb = tpb/pb;
tn_rateb = tnb/nb;

accuracyb = (tpb+tnb)/Nb;
sensitivityb = tp_rateb;
specificityb = tn_rateb;
precisionb = tpb/(tpb+fpb);
recallb = sensitivityb;
f_measureb = 2*((precisionb*recallb)/(precisionb + recallb));
gmeanb = sqrt(tp_rateb*tn_rateb);

%% Comparison Using Performance Ratio (PR) parameter %%    
    
ct=0;
st=0;
cf=0;
sf=0;
gt=0;
gf=0;
[m1 n1]=size(t1);
for i=1:m1
    for j=1:n1
        if t1(i,j)~=0 && c(i,j)~=0
            ct=ct+1;
        end
        if t1(i,j)~=0 && b(i,j)~=0
            st=st+1;
        end
        if t1(i,j)~=0 && t1(i,j)~=0
            gt=gt+1;
        end
        
        if (t1(i,j)~=0 && c(i,j)==0 || t1(i,j)==0 && c(i,j)~=0) 
            cf=cf+1;
        end
        if (t1(i,j)~=0 && b(i,j)==0 || t1(i,j)==0 && b(i,j)~=0)
            sf=sf+1;
        end
       
        if (t1(i,j)~=0 && t1(i,j)==0 || t1(i,j)==0 && t1(i,j)~=0)
            gf=gf+1;
        end
    end
end
CR=(ct/cf)*100;
BR=(st/sf)*100;
TR=(gt/gf)*100;
    
%% Display of Results %%    
figure,subplot(2,2,4),imshow(b),title(['Sobel,PR=',num2str(BR),',Fmeasure=',num2str(f_measureb)]);
    subplot(2,2,3),imshow(c),title( ['Canny,PR=',num2str(CR),',Fmeasure',num2str(f_measurec)]);
    subplot(2,2,1),imshow(rgb),title('BSD Image');
    subplot(2,2,2),imshow(t1),title(['Ground Truth,PR=',num2str(TR),',Fmeasure=',num2str(f_measuret)]);
    end
end
