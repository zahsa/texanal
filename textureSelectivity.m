clear all
%-------z-----------
% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));
% p='D:\Matlab space\matconvnet-1.0-beta25';
% addpath(genpath((p)));

% % add matconvnet directory
% folder = 'D:\Matlab space\matconvnet-1.0-beta25';
% b=addpath(genpath(folder));

%--------------------------


%% -----------setup-----------------
%--- mex -setup mex -setup C++
%--- mex -setup:C:\Users\zahra\AppData\Roaming\MathWorks\MATLAB\R2016a\mex_C_win64.xml C
%--- cd <MatConvNet>
%--- addpath matlab
%--- addpath C:\Program Files (x86)\Microsoft Visual Studio14.0\VC\bin\amd64_arm
%--- vl_compilenn
%--  vl_setupnn

%---------------------------------------




netPath='/media/zahra/DATA 4TB/Matlab space/Data/imagenet/';

% imagePath = '/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/WPSet2/Test/testImnet/';%
imagePath ='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/WPSet3/';
% imageMatPath = '/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/WPSet2/Test/';% 
imageMatPath = '/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/';

%% ------read images and save image names------------
% image_files=GetImageNames(imagePath,imageMatPath);

%% ---- load net architecture -----------------

netName='imagenet-vgg-m';
net=load([netPath netName '.mat']);
netlayers=net.layers;


convLayers=[];
filtersize=[];
    for i=1:size(net.layers,2)
        if strcmp(net.layers{1,i}.type,'conv') 
            convLayers=[convLayers i];
           
            if isfield(net.layers{1,i},'weights')
                filtersize=[filtersize size(net.layers{1,i}.weights{1,1},4)];
            else
                error('* ERROR-- cant find filters in net architecture *');
            end
        end
       
    end




%% ------load images--------------
load([imageMatPath 'ImageNames.mat']);
imageNum = length(image_files);

%% ---average image for normalization--
% avgIm=metaNorm.averageImage; %% for imagenet data
avgIm=averageImg(imagePath,image_files,net); %% for other image sets eg. texture

% save('avgIm','avgIm');

%% -------create activation maps--------
% [res,bestScore, bestclass]= classify_image_noGPU(im, net);

% actPath='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/WPSet2/Test/activation/';%
actPath='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/activation maps/';
%  if ~exist([nTopPath 'Layer',  num2str(convLayers(lay))   filesep],'dir')
%                mkdir([nTopPath 'Layer',  num2str(convLayers(lay))   filesep]);
%  end



batch_size_Test=10;
[imgAct_batch,imgLoc_batch]= createActMap(imageNum,image_files,imagePath,net,convLayers,filtersize,actPath,batch_size_Test,avgIm);
    
%%--So far we know for each image the maximum responce (i.e. maximum value in each activation map) that it can generate for each filter in each layer 
%%(the number of activation maps is num_img*num_filter*num_layer)

%% -----find n-top images for each filter-----
% ntopPath = '/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/WPSet2/Test/ntopIm/';%
ntopPath='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/top images/';

[Act_allBatchNtop,Loc_allBatchNtop,imnames_allbatchNTop]=nTopImages_sort(actPath,convLayers,ntopPath);

%% -----visualize by taking mean value of the location of n-top images-------
ntop=20;
% patchPath ='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/WPSet2/Test/nTopPatch/';%
patchPath='/media/zahra/DATA 4TB/zDownloads_driveE/texture stimulus/top patches/';

collectPatches(convLayers,net,filtersize,ntop,ntopPath,imagePath,patchPath)