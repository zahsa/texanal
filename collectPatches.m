function collectPatches(convLayers,net,filtersize,nTop,nTopPath,imagePath,patchPath)
% nTopPath = '/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/top images/';
% imagePath = '/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/WPSet/';
% patchPath ='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/top patches/';
load('size_featureMaps','size_featureMaps');

for lay=1:length(convLayers)
    
    for nfilt=1:filtersize(lay)
        
        
        load([nTopPath 'Layer',  num2str(convLayers(lay))  filesep 'ntop','.mat'],'Act_allBatchNtop','Loc_allBatchNtop','imnames_allbatchNTop');
        
        imnames_ntop=imnames_allbatchNTop{nfilt};
        
        for i=1:nTop
            imname=imnames_ntop{i};
            img=single(imread([imagePath imname]));
            
            [r c ch]=size(img);
            if ch==1 %is in gray scale!
                img2(:,:,1)=img;
                img2(:,:,2)=img;
                img2(:,:,3)=img;
                clear img;
                img=img2;
                clear img2;
            end
            img=imresize(img, [net.meta.normalization.imageSize(1) net.meta.normalization.imageSize(2)]);
            cropped=obtain_cropped_image(net, lay, Loc_allBatchNtop(i,:), img, size_featureMaps);
            imagePatches(:,:,:,i)=cropped;
            
        end
       
          if ~exist([patchPath 'Layer',  num2str(convLayers(lay))   filesep],'dir')
               mkdir([patchPath 'Layer',  num2str(convLayers(lay))   filesep]);
          end
            img=plot_joint_images(imagePatches,ceil(sqrt(size(imagePatches,4))), ceil(size(imagePatches,1)/7));
        imwrite(img,[patchPath 'Layer',  num2str(convLayers(lay))   filesep 'L', num2str(convLayers(lay)),'_f', num2str(nfilt),'.png']);
           save([patchPath 'Layer',  num2str(convLayers(lay))  filesep 'ntop','.mat'],'imagePatches');
    end
end
