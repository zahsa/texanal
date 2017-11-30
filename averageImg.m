function avIm=averageImg(imagePath,image_files,net)
sumIm=zeros([net.meta.normalization.imageSize(1:2),3]);

for i=1:length(image_files)
        
        img=single((imread([imagePath ,  image_files{i}])));
        
        
        [~,~,t]=size(img);
        if t==1 % is a gray scale and we need a color image.
            img=repmat(img,1,1,3);
        end
        img=imresize(img,net.meta.normalization.imageSize(1:2));
        sumIm=img+sumIm;
    
end
imageNum=length(image_files);
avIm=sumIm./imageNum;
figure;imshow(uint8(avIm))