function f = Twosdf2circle(nrow,ncol, ic1,jc1,r1,ic2,jc2,r2)



[X,Y] = meshgrid(1:ncol, 1:nrow);


f1 = sqrt((X-jc1).^2+(Y-ic1).^2)-r1;
f2 = sqrt((X-jc2).^2+(Y-ic2).^2)-r2;

k = -((ic1-ic2))/(jc1-jc2);
b = (jc1+jc2)/2-k*(ic1+ic2)/2;

s = X-(k*Y+b);

f = f1.*(s>=0)+f2.*(s<0);
%f=sdf2circle(100,50,51,25,10);figure;imagesc(f)