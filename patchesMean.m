function patchMean()
r=mean(squeeze(imageParts(:,:,1,1:params.n_mean)), 3);
    g=mean(squeeze(imageParts(:,:,2,1:params.n_mean)), 3);
    b=mean(squeeze(imageParts(:,:,3,1:params.n_mean)), 3);
      
    imgMean(:,:,1)=r;
    imgMean(:,:,2)=g;
    imgMean(:,:,3)=b;
    
    imgStd(:,:,1)=std(squeeze(double(imageParts(:,:,1,1:params.n_mean))), [],3);
    imgStd(:,:,2)=std(squeeze(double(imageParts(:,:,2,1:params.n_mean))),[], 3);
    imgStd(:,:,3)=std(squeeze(double(imageParts(:,:,3,1:params.n_mean))), [],3);

  
    imwrite((imgMean./255),[path2save 'L', num2str(lay),'_f', num2str(nfilt),'.png']);
  
    save([path2save 'L', num2str(lay),'_f', num2str(nfilt),'.mat'],'imgMean', 'imgStd');