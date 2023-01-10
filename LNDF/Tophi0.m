%The following codes are to convert the rough segmentation result to the
%initial segmentation contour

clc;clear;close all;
phi0=imread('segResult_07.bmp');%read SegNet segmentation result
phi0=double(phi0);
[w,h]=size(phi0);
for i=1:w
    for j=1:h
        if (phi0(i,j)==255)
            phi0(i,j)=1;
        end
        if (phi0(i,j)==0)
            phi0(i,j)=-1;
        end
    end
end
save('phi0_1','phi0');

