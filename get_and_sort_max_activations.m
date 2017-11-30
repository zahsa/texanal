function get_and_sort_max_activations(net,params, specific_layers)

if nargin<3
    layers2compute=1:params.n_convolutional;
else
    layers2compute=specific_layers;
    new=[];
    for kk=1:length(layers2compute)
        new=[new find(conv_layers==layers2compute(kk))];
    end
    layers2compute=new;
end

% localization: arreglat
% adapted to the new format of maximum activations
%adapted from: script_get_global_maximum_activation

params=params_default_testDataset(params);
params=params_default_maximum_activation(params);
params=params_default_dataset(params);

[conv_layers, num_filters]=find_conv_layers_and_num_filters(net);
conv_layers=conv_layers(1:params.n_convolutional);
num_filters=num_filters(1:params.n_convolutional);
cumsum_num_filters=[0 cumsum(num_filters)];

try
    load([params.path_results 'ImageNames.mat']);
    num_images=length(image_files);
catch
    error(['* ERROR *  run GetImageNames.m']);
end

path2save=[params.pathMaxActiv filesep];
if ~exist(path2save,'dir')
    mkdir(path2save);
end


filenames=dir(params.path_testDataset);

num_max_activation=100;




for lay=layers2compute%1:params.n_convolutional  %z we want to find the 100-top scoring images for the filters of all layer
    j_ini=1;
%     while exist([path2save 'L', num2str(conv_layers(lay)) filesep 'MaxGlobal_', num2str(j_ini),'.mat'],'file')
%         load([path2save 'L', num2str(conv_layers(lay))  filesep 'MaxGlobal_', num2str(j_ini),'.mat']);
%         anterior_tmp=layer_maximum.values;
%         j_ini=j_ini+1;
%         if j_ini>100
%             break;
%         end
%     end
    for j=j_ini:num_max_activation  %z in order to find 100 images for each filter ... num_max_activation=100
        disp([' L', num2str(conv_layers(lay)) ' searching for new maximum ', num2str(j), '...']); 
        clear global_names
        clear global_maximum
        clear global_locations
        clear comprovacio;
        
        
        for i=3:5%length(filenames) %z search in all batches....each batch contains 50*96 values (i.e., the maximum value of each activation map for each of 50 images) filenames is batch file names
            %             disp(['                     ', num2str(i-2) ,' / ', num2str(length(filenames)-2) ])
            
            load([params.path_testDataset filenames(i).name]); %z load the maximum activation values for all filters in all layers {[50*96][50*256][50*512]...}
            current_matrix=maximum_batch{1,lay};
            [rcm, ccm]=size(current_matrix);
            if j==1
                anterior=Inf.*ones(size(current_matrix));
            else
                anterior=repmat(anterior_tmp,size(current_matrix,1),1);
            end
            comprovacio_idx=(current_matrix>=anterior);
            %                 comprovacio(:,:,1)=anterior;
            %                 comprovacio(:,:,2)=current_matrix;
            %                 [valors, idx]=max(comprovacio,[],3);
            %                 current_matrix(current_matrix ~= valors)=-Inf;
            current_matrix(comprovacio_idx)=-Inf;
            
            %                 crr_names=repmat(class_activation.name,size(current_matrix,2));
            clear anterior
            [x3, id3]=sort(current_matrix,'descend'); %z sort the activation map of each ????????????????????????
            clear current_matrix;
            
            first_row_idx=id3(1,:);
            first_row_vals=x3(1,:);
            columnes=[1:ccm];
            columnes=repmat(columnes,rcm,1);
            columnes=columnes(:);
            files=id3(:);
            clear x3
            clear id3
            
            [indexes]=sub2ind([rcm, ccm],files,columnes);
            clear files
            clear columnes
            
            resorted_locations=location_batch{1,lay}(indexes);
            resorted_locations=reshape(resorted_locations, [rcm, ccm]);
            current_locations=resorted_locations(1,:);
            
            clear resorted_locations;
            c_a=names_batch;
            clear class_activation;
            crr_names=repmat(c_a,1,ccm);
            
            resorted_names=crr_names(indexes);
            clear crr_names
            resorted_names=reshape(resorted_names,[rcm, ccm]);
            current_names=resorted_names(1,:);
            
            if i==3
                global_maximum=first_row_vals;
                global_names=current_names;
                global_locations=current_locations;
            else
                ant_names=global_names;
                
                new_maximums_idx=find(global_maximum<first_row_vals);
                global_maximum(new_maximums_idx)=first_row_vals(new_maximums_idx);
                global_names(new_maximums_idx)=current_names(new_maximums_idx);
                global_locations(new_maximums_idx)=current_locations(new_maximums_idx);
                
            end
            
            
        end
        
        layer_maximum.values=global_maximum;
        layer_maximum.names=global_names;
        layer_maximum.loc=global_locations;
        
        if ~exist([path2save 'L',  num2str(conv_layers(lay))   filesep],'dir')
            mkdir([path2save 'L',  num2str(conv_layers(lay))  filesep ]);
        end
%         save([path2save 'L', num2str(conv_layers(lay)) filesep 'MaxGlobal_', num2str(j),'.mat'],'layer_maximum');
        anterior_tmp=layer_maximum.values;
    end
    
end


