function u = LBF_2D(u,Img,Ksigma,KI,KONE,alpha,nu,lambda1,lambda2,timestep,timestep2,epsilon,flag)
    
    [K,absR]=Curvature_central(u);                             

    DrcU=(epsilon/pi)./(epsilon^2.+u.^2);              

    [f1, f2] = localBinaryFit(Img, u, KI, KONE, Ksigma, epsilon);

    s1=lambda1.*f1.^2-lambda2.*f2.^2;                   
    s2=lambda1.*f1-lambda2.*f2;
    dataForce=(lambda1-lambda2)*KONE.*Img.*Img+conv2(s1,Ksigma,'same')-2.*Img.*conv2(s2,Ksigma,'same');
                                                        
    A=-DrcU.*dataForce;                                
    P= alpha*(4*del2(u)-K);                             
    L=nu.*DrcU.*K;                                      

switch flag
    case 'LIM'
        u=u+timestep*(P+L+A);
    case 'RD'
        u = u + timestep*(L+A);
        u = u + timestep2*4*del2(u);
end
 
 
function [f1, f2]= localBinaryFit(Img, u, KI, KONE, Ksigma, epsilon)
% compute f1 and f2
Hu=0.5*(1+(2/pi)*atan(u./epsilon));                    

I=Img.*Hu;
c1=conv2(Hu,Ksigma,'same');                             
c2=conv2(I,Ksigma,'same');                              
f1=c2./(c1);                                            
f2=(KI-c2)./(KONE-c1);                                  



