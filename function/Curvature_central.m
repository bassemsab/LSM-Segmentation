function [Kappa, absR] = Curvature_central(phi)

    [nx,ny]=gradient(phi);
    absR = sqrt(nx.^2+ny.^2);
    absR = absR +(absR==0)*eps;
   
    [nxx,junk]=gradient(nx./absR);  
    [junk,nyy]=gradient(ny./absR);
    Kappa=nxx+nyy;