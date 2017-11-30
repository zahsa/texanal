function image_files=GetImageNames(basepath, path2save)
% basepath='D:\IvetPhD\ILSVRC2012_img_train\';
llista_directori=dir(basepath);
image_files={};
count=0;
for i=3:length(llista_directori)
    if isdir([basepath llista_directori(i).name])
        imagenames=dir([basepath llista_directori(i).name filesep]);
        for j=3:length(imagenames)
            if strcmp(imagenames(j).name(end-3:end), '.jpg') ||  strcmp(imagenames(j).name(end-3:end), '.png') ||  strcmp(imagenames(j).name(end-3:end), 'JPEG')
                count=count+1;
                image_files{count,1}=[llista_directori(i).name filesep imagenames(j).name];
            end
        end
    end
end
if ~exist(path2save,'dir')
    mkdir(path2save);
end

save([path2save 'ImageNames.mat'],'image_files');
end