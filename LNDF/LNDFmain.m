%The following codes are to implement the Local Nakagami Distribution
%Fitting (LNDF)energy based active contour model for ultrasound image segmentation
%author:Cui Wenchao
%date:2021.08.29;


clear;close all;clc;

filename=uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files';'*.*','All Files' },'mytitle');
img1=imread(filename);
Img = double(img1(:,:,1));
sigma =8;% the key parameter which needs to be tuned properly.
kernel = fspecial('gaussian',2*round(2*sigma)+1,sigma);
figure(1);
imshow(Img,'border','tight','initialmagnification',200,'displayrange',[0 255]); colormap(gray);axis off,axis equal

% %%%% Manual initialization 1 
% c0=1;bw=roipoly;
% %%%% Manual initialization 2
%roi=drawrectangle;
%c0=1;bw=createMask(roi)
% two boxes
% roi2=drawrectangle;
% bw2=createMask(roi2);
% bw=bw|bw2;
% %%%% Manual initialization 3
% roi=drawcircle;
% c0=1;bw=createMask(roi);
%phi0=-c0*bw+c0*(1-bw);%draw a closed line

load phi0_1.mat;%import initialization level set function
figure(2);       
imshow(Img,'border','tight','initialmagnification',200,'displayrange',[0 255]);colormap(gray);hold on;axis off,axis equal;
contour(phi0,[0 0],'r','LineWidth',2);

phi=phi0;% initial level set function
timestep = .2;%iteration time step
mu=1;%the parameter of the penalize term(signed distance term)
nu=0.003*255^2;%the parameter of the length term
lamda=50;%the coefficient of the image term
epsilon =1;%the parameter of the regularized version of Heaviside function H
iter_outer=50;%outer iteration number
iter_inner=10;%inner iteration number
n=0;

t1=cputime;
while n <iter_outer  
      phi_new= LNDF(Img,phi,mu,nu,lamda,timestep,epsilon,kernel,iter_inner);
      
      if mod(n,5) == 0
      figure(3)
      imshow(Img,'border','tight','initialmagnification',200,'displayrange',[0 255]);colormap(gray)
      hold on;contour(phi_new,[0 0],'r','LineWidth',2);axis off,axis equal;
      iterNum=[num2str(n), ' iterations'];        
      title(iterNum);        
      hold off;
      end
      % Check whether the convergence is reached
      if norm(phi_new-phi)<0.5
          break;
      else
           phi=phi_new;
           n=n+1;
      end
end
t=cputime-t1;%Running time

figure
imshow(Img,'border','tight','initialmagnification',200,'displayrange',[0 255]); colormap(gray);hold on;axis off,axis equal
%imagesc(Img, [0 255])
contour(phi_new,[0 0],'r','LineWidth',2);
hold on;
contour(phi0,[0 0],'b','LineWidth',2);
totalIterNum=[num2str(n), ' iterations'];
title(['Final contour, ', totalIterNum]);
imwrite(phi_new,'result_01.bmp');%