function r = RegularizeF(phi)
% This codes were downloaded from website:
% http://www.engr.uconn.edu/~cmli/
% Thanks for Dr.Li Chunming sharing his source codes.
% Date: 15/7/2011

% [ux,uy] = gradient(phi);
% s = sqrt(ux.^2+uy.^2);
% d = 1/(2*pi)*sin(2*pi*s).*(s<=1) + (s-1).*(s>=1);
% d = d./s;
% [uxx,uxy] = gradient(ux.*s);
% [uyx,uyy] = gradient(uy.*s);
% 
% r = uxx + uyy;

[phi_x,phi_y]=gradient(phi);
s=sqrt(phi_x.^2 + phi_y.^2);
a=(s>=0) & (s<=1);
b=(s>1);
ps=a.*sin(2*pi*s)/(2*pi)+b.*(s-1);  % compute first order derivative of the double-well potential p2 in eqaution (16)
dps=((ps~=0).*ps+(ps==0))./((s~=0).*s+(s==0));  % compute d_p(s)=p'(s)/s in equation (10). As s-->0, we have d_p(s)-->1 according to equation (18)
r = div(dps.*phi_x - phi_x, dps.*phi_y - phi_y) + 4*del2(phi);  

function f = div(nx,ny)
[nxx,junk]=gradient(nx);  
[junk,nyy]=gradient(ny);
f=nxx+nyy;