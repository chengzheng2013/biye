function nlabels = SLIC(img)
%img = imread('27.jpg');
sigma = 1;%标准差大小
window = double(uint8(3*sigma)*2+1);
H = fspecial('gaussian', window, sigma);%滤波参数
img = imfilter(img, H, 'replicate');
figure;
title('高斯滤波图像');
imshow(img);
hold on;
[r, c, channel] = size(img);
disp(size(img));
%灰度图像的处理方式
if channel == 1
    for i=1:r
        for j=1:c
            A((i-1)*c+j, 1) = img(i,j);
            A((i-1)*c+j, 2) = img(i,j);
            A((i-1)*c+j, 3) = img(i,j);
        end
    end
    img = reshape(A, r,c,3);
    disp(img);
end

img_size = size(img);   %三个元素：图像的高、图像的宽、图像的通道数
disp(img_size);
%设定超像素个数
K = 20;
%设定超像素紧凑系数
m_compactness = 20;

%转换到LAB色彩空间
cform = makecform('srgb2lab');       %rgb空间转换成lab空间 matlab自带的用法
img_Lab = applycform(img, cform);    %rgb转换成lab空间
%img_Lab = RGB2Lab(img);  %不好用不知道为什么
%imshow(img_Lab)
% %检测边缘
% img_edge = DetectLabEdge(img_Lab);
% imshow(img_edge)

%得到超像素的LABXY种子点信息
%K为超像素个数
disp(fprintf('图像长:%d, 图像宽:%d', c, r));
img_sz = img_size(1)*img_size(2);%img_sz图像大小
disp(fprintf('图像大小: %d',img_sz));
superpixel_sz = img_sz/K;        %超像素的大小superpixel_sz
disp(fprintf('超像素大小: %f', superpixel_sz));
STEP = uint32(sqrt(superpixel_sz));%超像素的边长STEP
disp(fprintf('超像素边长:%f', STEP));
xstrips = uint32(img_size(2)/STEP);%图像每一行的超像素个数xstrips
disp(fprintf('xstrips:%d', xstrips));
ystrips = uint32(img_size(1)/STEP);%图像每一列的超像素个数ystrips
disp(fprintf('ystrips:%d', ystrips));
xstrips_adderr = double(img_size(2))/double(xstrips);%每一个聚类中心的x方向移动距离
disp(fprintf('xstrips_adderr:%f', xstrips_adderr));
ystrips_adderr = double(img_size(1))/double(ystrips);%每一个聚类中心的y方向移动距离
disp(fprintf('ystrips_adderr:%f', ystrips_adderr));
numseeds = xstrips*ystrips;   %numseeds种子点的个数
disp(fprintf('种子点个数:%d', numseeds));
%种子点xy信息初始值为晶格中心亚像素坐标
%种子点Lab颜色信息为对应点最接近像素点的颜色通道值
kseedsx = zeros(numseeds, 1);
kseedsy = zeros(numseeds, 1);
kseedsl = zeros(numseeds, 1);
kseedsa = zeros(numseeds, 1);
kseedsb = zeros(numseeds, 1);
n = 1;
%将所有初始种子点的数值具体化
for y = 1: ystrips
    for x = 1: xstrips 
        kseedsx(n, 1) = (double(x)-0.5)*xstrips_adderr;
        kseedsy(n, 1) = (double(y)-0.5)*ystrips_adderr;
        kseedsl(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 1);
        kseedsa(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 2);
        kseedsb(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 3);
        n = n+1;
    end
end

n = 1;
%根据种子点计算超像素分区
%klabels每个元素的标签
[klabels, kseedsx, kseedsy] = PerformSuperpixelSLIC(img_Lab, kseedsl, kseedsa, kseedsb, kseedsx, kseedsy, STEP, m_compactness);

plot(kseedsx, kseedsy,'*r');
hold off;
%
img_Contours = DrawContoursAroundSegments(img, klabels);

%合并小的分区
nlabels = EnforceLabelConnectivity(img_Lab, klabels, K); 

%根据得到的分区标签找到边界
img_ContoursEX = DrawContoursAroundSegments_EX(img, nlabels);
M = max(max(nlabels));
random_color = zeros(M,3);
for i=1:M
    random_color(i,1) =  randi([0,255]);
    random_color(i,2) =  randi([0,255]);
    random_color(i,3) =  randi([0,255]);
end
for m =1:r
    for n=1:c
        img_ContoursEX(m,n) = random_color(nlabels(m,n));   
    end
end
figure;
title('img_contoursEX');
imshow(img_ContoursEX);







