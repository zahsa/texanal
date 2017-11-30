function nTopImages()

imMxBatch=dir(actPath);
topnum=100;

for t=1:topnum
    for lay=1:length(convLayers)
        
        for b=3:length(imgMxBatch) %% in each batch find a maximum image
            
            load([actPath imMxBatch(i).name],'imgMxAct_batch','imgMxLoc_batch','batch_img_names');
            
            mxActImg=imgMxAct_batch{1,lay};
            mxLocImg=imgMxLoc_batch{1,lay};
            mxActImg=batch_img_names{1,lay};

            %---get rid of all taken images---
            if ismember(b,nxtMxImgInAllBatch.batchnum)
                
            indexes=1:size(mxActImg,2);
            mxActImg(mxImgInBatch_i,indexes)=-inf;
            
            %--compare the new max with the previous max
            [mxImgInBatch_v,mxImgInBatch_i]=max(mxActImg);
            if mxImgInThisBatch>mxImgInAllBatch
                nxtMxImgInAllBatch.value(t)=mxImgInThisBatch;
                nxtMxImgInAllBatch.imgname=batch_img_names()
            end
            
            
        end
    end
end