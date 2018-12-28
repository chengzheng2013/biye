function [g] = processing(img,moshi)

se = strel('disk', 3);

[r,c] = size(img);
G = zeros(r,c);
for i = 1:r
    for j = 1:c
        if img(i,j)^2>255
            G(i,j)=255;
        else
            G(i,j) = img(i,j)^2;
        end
    end
end

if nargin == 1
    g = imclose(img, se);
end
if moshi == 1
    g = imerode(img, se); %gΪ��ʴͼ��
elseif moshi == 2
    g = imopen(img, se);%g1Ϊ������
elseif moshi == 3
    g = imclose(img,se);%g2������
elseif moshi == 4
    g2 = imclose(img, se);
    g = imopen(g2, se);%g3Ϊ�տ�����
elseif moshi == 5
    g =  imdilate(img, se);%g4Ϊ��������
elseif moshi == 6
    g1 = imopen(img, se);
    g2 = img-g1;
    g3 = imclose(img, se);
    g4 = g3 - img;
    
    g = g2+img-g4;
else
    err('param should be 1-5');
end

%subplot(1,2,1),imshow(img),title('ԭͼ');
%subplot(1,2,2),imshow(img_close), title('��ʴͼ��');