%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fuzzy connectedness segmentation example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Read image and scale to [0,1]
I=double(imread('27.jpg'))./255;

%We subsample by factor of 2 to make  things run a bit faster when playing around
%I=I(1:2:end,1:2:end,:);
disp(sprintf('Image size: %d x %d',size(I,1),size(I,2)));
[r,c]=size(I);

%Compute adjacency
%计算邻接Uα(c,d)
n=1;
k1=0.1;
%A表示图像中任意两点的邻接度Uα(c,d)
%A(r*c,r*c)
%图像中只有当前点和其4邻域的像素点具有邻接度，其余为0
A=adjacency(I,n,k1);

%Compute affinity
%计算亲和度
k2=2;
K=affinity(I,A,k2);
disp(K);

%Seed points, numbered from 1 and up
S=zeros(size(I));
%[x,y]=ginput(1);%获取两个种子点，其余非种子点为0
%S(ceil(x*128),ceil(y*128))=1;%进行设置种子点处理
S(60,60)=1;
S(65,60)=1;
%disp(x*128);disp(y*128);
%S(75:80,25:30)=1; %coat
%S(60:65,40:45)=1; %hand
%S(110:115,20:25)=1; %leg

%S(10:15,80:85)=2; %sky
%S(100:105,110:125)=3; %grass


%Show seeds overlayed on image
I_rgb=repmat(I,[1,1,3]); %make rgb image (required by imoverlay)

figure(1)
image(I_rgb)
imoverlay(S,S>0); %requires image in range [0,1]
title('Seed regions');


%Compute FC
%图像中所有像素点相对种子点的模糊连接度矩阵FC
%K亲和度矩阵
%S为种子点矩阵，mask表示
%S为mask图像,K为模糊亲和度
disp(sprintf('Processing...'));
FC=afc(S,K); %Absolute FC

%Show resulting FC-map
figure(2)
imagesc(FC,[0,1])
colorbar
title('Fuzzy connectedness map');

%Threshold value
thresh=0.8;

%Show the 0.75-connected component overlayed on original image
figure(3)
image(I_rgb)
imoverlay(FC,FC>thresh);
title(sprintf('Fuzzy connected component at level %.2f',thresh));

