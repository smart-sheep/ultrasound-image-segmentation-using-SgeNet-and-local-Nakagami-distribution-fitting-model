%The following codes are to convert the 8-bit segmentation results to
%binary results
%author:Cui wenchao
% date:2021.9.11
for i=1:9
    str1=sprintf('pixelLabel_0%d.png',i);
    str2=sprintf('segResult_0%d.bmp',i);
    I=imread(str1);
    J=I==1;
    imwrite(J,str2);
end
for i=10:64
    str1=sprintf('pixelLabel_%d.png',i);
    str2=sprintf('segResult_%d.bmp',i);
    I=imread(str1);
    J=I==1;
    imwrite(J,str2);
end    