function [ p,r,F ] = fmeasure( gt,m )


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
end

