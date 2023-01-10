function phi = LNDF(I,phi,mu,nu,lamda,timestep,epsilon,K,iter_inner)
%The following codes are to implement the Local Nakagami Distribution
%Fitting (LNDF)energy based active contour model for ultrasound image segmentation
%author:Cui Wenchao
%date:2021.08.29;
Hphi = Heaviside(phi,epsilon);
[a1_matrix,a2_matrix,b1_matrix,b2_matrix]=LNF_paraMatrix(I,K,Hphi);
e1=conv2(log(gamma(a1_matrix)+eps),K,'same')+conv2(a1_matrix.*log(b1_matrix+eps),K,'same')+I.^2.*conv2(a1_matrix./(b1_matrix+eps),K,'same')-log(I+eps).*conv2(2*a1_matrix-1,K,'same')-conv2(a1_matrix.*log(a1_matrix+eps),K,'same');
e2=conv2(log(gamma(a2_matrix)+eps),K,'same')+conv2(a2_matrix.*log(b2_matrix+eps),K,'same')+I.^2.*conv2(a2_matrix./(b2_matrix+eps),K,'same')-log(I+eps).*conv2(2*a2_matrix-1,K,'same')-conv2(a2_matrix.*log(a2_matrix+eps),K,'same');
for kk=1:iter_inner
    phi = NeumannBoundCond(phi);
    div=curvature_central(phi);    % div()
    DiracPhi = Delta(phi,epsilon);
    ImageTerm=-lamda*DiracPhi.*(e1-e2);%data fidelity term
    penalizeTerm=mu*(4*del2(phi)-div);%penalize term
    lengthTerm=nu.*DiracPhi.*div;%length term
    phi=phi+timestep*(lengthTerm+penalizeTerm+ImageTerm);
end

function H = Heaviside(phi,epsilon)
H = 0.5*(1+(2/pi)*atan(phi./epsilon));

function Delta_h = Delta(phi,epsilon)
Delta_h = (epsilon/pi)./(epsilon^2+phi.^2);

function [a1_matrix,a2_matrix,b1_matrix,b2_matrix]=LNF_paraMatrix(I,K,Hphi)
%This function is to compute the local Nakagami para matrix using moment estimator (ME)in the proposed LNDF active contour
% I:ultrasound image
% kernel: Gaussian kernel function
% Hphi:Heaviside function of the level set phi
% a1_matrix,a2_matrix: the fitting shape parameter matrix of object and background
% b1_matrix,b2_matrix: the fitting scale parameter matrix of object and background
%ME:(see Eq.2 in Ref.[1])
%    a=b^2/var(X^2);
%    b=E[X^2] ;
%Ref:[1]Abdi A, Kaveh M. Performance comparison of three different estimators for the Nakagami m parameter using 
%               Monte Carlo simulation[J]. IEEE communications letters, 2000, 4(4): 119-121..
% author:Cui Wenchao
% date:2021.08.29
conv_K_H1=conv2(Hphi,K,'same');
conv_K_H2=conv2(1-Hphi,K,'same');
conv_K_I4H1=conv2(I.^4.*Hphi,K,'same');
conv_K_I4H2=conv2(I.^4.*(1-Hphi),K,'same');
conv_K_I2H1=conv2(I.^2.*Hphi,K,'same');
conv_K_I2H2=conv2(I.^2.*(1-Hphi),K,'same');
b1_matrix=conv_K_I2H1./(conv_K_H1+eps);
b2_matrix=conv_K_I2H2./(conv_K_H2+eps);
var1_local=(conv_K_I4H1-2.*b1_matrix.*conv_K_I2H1+b1_matrix.^2.*conv_K_H1)./(conv_K_H1+eps);
var2_local=(conv_K_I4H2-2.*b2_matrix.*conv_K_I2H2+b2_matrix.^2.*conv_K_H2)./(conv_K_H2+eps);
a1_matrix=b1_matrix.^2./(var1_local+eps);
a2_matrix=b2_matrix.^2./(var2_local+eps);



function div = curvature_central(u)
% compute curvature for u with central difference scheme
[ux,uy] = gradient(u);
normDu = sqrt(ux.^2+uy.^2+1e-10);
Nx = ux./normDu;
Ny = uy./normDu;
[nxx,~] = gradient(Nx);
[~,nyy] = gradient(Ny);
div = nxx+nyy;

function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);