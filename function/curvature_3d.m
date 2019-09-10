function kappa = curvature_3d(phi)

[Fx,Fy,Fz]=gradient(phi);
absF=sqrt(Fx.^2+Fy.^2+Fz.^2);
absF= absF + (absF==0).*eps;
[Fxx,Fyx,Fzx] = gradient(Fx./absF);
[Fxy,Fyy,Fzy] = gradient(Fy./absF);
[Fxz,Fyz,Fzz] = gradient(Fz./absF);
kappa = Fxx + Fyy + Fzz;

