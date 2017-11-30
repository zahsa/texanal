function [imgMxAct_batch,imgMxLoc_batch]= createActMap(num_images,image_files,imagePath,net,convLayers,filtersize,actPath,batch_size_Test,avIm)


% random_order=randperm(num_images);

for iimg=1:batch_size_Test:num_images
    tic
    countBatch=0;
    
    for k=iimg: min(iimg + batch_size_Test-1, num_images);
        
%         img=single((imread([imagePath ,  image_files{random_order(k)}])));
        img=single((imread([imagePath ,  image_files{k}])));

        countBatch=countBatch+1;
%         batch_img_names{countBatch}= image_files{random_order(k)};
        
        batch_img_names{countBatch}= image_files{k};
        
        [~,~,t]=size(img);
        if t==1 % is a gray scale and we need a color image.
            img=repmat(img,1,1,3);
        end
        img=imresize(img,net.meta.normalization.imageSize(1:2));
        
        
        im_ = single(img);
        
        
        im_ = im_ - single(avIm) ;
    
        
        
        
        setImgs(:,:,:,countBatch)=im_;
        
    end
    
    [res,bestscore,bestclass]= classify_image_noGPU(setImgs, net);
    
    
    for cl=1:length(convLayers)
        size_feature_maps(cl,:)=size(res(cl+1).x);
        
        actMapMat=res((convLayers(cl))+1).x;
        actMapVect=(reshape(gather(actMapMat),[],filtersize(cl),size(setImgs,4)));
        
        [imgMaxActVal, imgMaxActLoc]=max(actMapVect,[],1); %find the max activation value of each image
        imgMxAct_batch{cl}=squeeze(imgMaxActVal)';
        imgMxLoc_batch{cl}=squeeze(imgMaxActLoc)';
        imgAct_batch{cl}=actMapVect;

    end
    disp([' activation map created for:   ', num2str(k) ,'/', num2str(num_images) , '(',num2str(100*(k)/(num_images)),'%)    [', num2str(toc), 'sec.]']);
    save([actPath 'actImgBatch_', num2str(k),'.mat'],'imgMxAct_batch','imgMxLoc_batch','imgAct_batch','bestscore','bestclass','batch_img_names','res','-v7.3')
    save('size_feature_maps','size_feature_maps');
end