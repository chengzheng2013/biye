clc;
clear;
im=imread('26.png');
figure(1);
title('原图');
imshow(im);

%im=add_noise(im);
%figure(2)
%title('加噪声图像');
%imshow(im);
%figure(1);
%title('原图');
%imshow(im);
%[im]=lashen(im);
%用遗传算法得出最优的模糊熵H，以及其对应的4个阈值
[thres] = Thres(im);
disp(thres);
[H,A1,C1,A2,C2]=yichuansuanfa(thres,im);
b1=(A1+C1)/2;
b2=(A2+C2)/2;
B1=min(b1,b2);
B2=max(b1,b2);
disp(B1);disp(B2);
threshold(im,B1,B2);
