function [res,bestScore, bestclass]= classify_image_noGPU(im , net)
metaNorm=net.meta.normalization;
    
%     im_ = single(im);
%   
%    if nargin >2
%          im_ = imresize(im_, metaNorm.imageSize(1:2)) ;
%          try
%              
%             if size(metaNorm.averageImage,1)==1
%                 metaNorm.averageImage=repmat(metaNorm.averageImage,[metaNorm.imageSize(1:2) 1 ]);
%             end
%             if size(metaNorm.averageImage,3)~=metaNorm.imageSize(3)
%                  metaNorm.averageImage=repmat(metaNorm.averageImage,[1,1,metaNorm.imageSize(3)]);
%             end
%             if size(metaNorm,4)~= size(im_,4)
%                 metaNorm.averageImage=repmat(metaNorm.averageImage, [1,1,1, size(im_,4)]);
%             end
%             im_ = im_ - single(metaNorm.averageImage) ;
%          catch
%              warning(' * WARNING * : no normalization is done due an error');
%          end
%     end
    for i=1:size(net.layers,2)
        
        if strcmp(net.layers{1,i}.type,'softmaxloss')
            net.layers{1,i}.type='softmax';
        end
    end
    % run the CNN
    
    %converting to GPU
%     net_gpu = vl_simplenn_move(net, 'gpu');
    
    %gpuArray transfering the data from CPU to GPU
%     res = vl_simplenn(net, im_) ;
    res = vl_simplenn(gather(net), gather(im)) ;

    % show the classification result
    scores = squeeze(gather(res(end).x)) ;
    [bestScore, bestclass] = max(scores) ;
%     figure(1) ; clf ; imagesc(im) ;
%     title(sprintf('%s (%d), score %.3f',net.classes.description{best}, best, bestScore)) ;
end
