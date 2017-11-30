function [Act_allBatchNtop,Loc_allBatchNtop,imnames_allbatchNTop]=nTopImages_sort(actPath,convLayers,nTopPath)
% nTopPath='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/top images/';
imMxBatch=dir(actPath);
nTop=20;

    for lay=1:length(convLayers)
        Act_allBatchNtop=[];
        Loc_allBatchNtop=[];
        imnames_allbatchNTop={};
        for b=3:length(imMxBatch) %% in each batch find a maximum image
            
            load([actPath imMxBatch(b).name],'imgMxAct_batch','imgMxLoc_batch','batch_img_names');
            
            Act_thisBatch=imgMxAct_batch{1,lay};
            Loc_thisBatch=imgMxLoc_batch{1,lay};
            imnames_thisBatch=batch_img_names';

           
           %-- merge and sort -- 
           [srtAct_allBatch_v,srtAct_allBatch_i]=sort([Act_thisBatch;Act_allBatchNtop],'descend');
           
           srtLoc_allBatch_v=[];
           Loc_AllBatch=[Loc_thisBatch;Loc_allBatchNtop];
           for i=1:size(Loc_AllBatch,2)
               srtLoc_allBatch_v(:,i)=Loc_AllBatch(srtAct_allBatch_i(:,i),i);
           end
           
           for i=1:size(Loc_AllBatch,2)
               if ~isempty(imnames_allbatchNTop)
                   
                   imnames_allBatch=[imnames_thisBatch;imnames_allbatchNTop{i}];
               else
                   imnames_allBatch= imnames_thisBatch;
               end
               srtImg_allBatch_v{i}=imnames_allBatch(srtAct_allBatch_i(:,i));
           end

    
           %---extract the n-top images
           if size(srtAct_allBatch_v,1)<=nTop
               Act_allBatchNtop=srtAct_allBatch_v;
               Loc_allBatchNtop=srtLoc_allBatch_v;
               imnames_allbatchNTop=srtImg_allBatch_v;
           else
           Act_allBatchNtop=srtAct_allBatch_v(1:nTop,:);
           Loc_allBatchNtop=srtLoc_allBatch_v(1:nTop,:);

           for i=1:size(srtImg_allBatch_v,2)
               imnames_allbatchNTop{i}=srtImg_allBatch_v{i}(1:nTop);
           end
           end
           
           %--save the n-top images for this layer
         
           
           if ~exist([nTopPath 'Layer',  num2str(convLayers(lay))   filesep],'dir')
               mkdir([nTopPath 'Layer',  num2str(convLayers(lay))   filesep]);
           end
           save([nTopPath 'Layer',  num2str(convLayers(lay))  filesep 'ntop','.mat'],'Act_allBatchNtop','Loc_allBatchNtop','imnames_allbatchNTop');

        end
        
    end
