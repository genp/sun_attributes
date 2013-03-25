%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for calculating the test and train kernel from the whole dataset
%
%   kernel_ind: the index of the kernel to calculate (1-4)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function calc_master_kernel(kernel_ind,save_path, feature_path)


% make all the variables globals
global GVARS
%Check that global variables have been loaded
try
    GVARS.attributes;
catch
    attributes_globals;
end
    curFeat = kernel_ind;  
    %% test/train set


test_set_inds = single(1);
train_set_inds = single(1:length(GVARS.images));

    %% kernel configuration
    parameterCell = set_up_kernel_params();

    %% calculate per feature kernels
    
    kernel_save_name = fullfile(save_path, sprintf('%s_kernel_size%d_%s','Train', length(train_set_inds), get_kernel_filename(parameterCell{curFeat})));    

   %Check if precomputed
if(~exist(kernel_save_name,'file')) 
    fprintf('Calculating kernel %s  ...\n', get_kernel_filename(parameterCell{curFeat}));
    if(curFeat == 1 || curFeat == 3 || curFeat == 2 || curFeat == 4)
        % recalculate kernel
        % load, pack, save features for all images first
        features_all{curFeat} = [];
        feature_save_file_name = fullfile(feature_path, ...
            sprintf('%s_image_features.mat',parameterCell{curFeat}.featureName));
        if(exist(feature_save_file_name,'file'))
            load(feature_save_file_name);
            features_all{curFeat} = feature_vector;
        else
           disp('Need to pre-compute features!');
           return;
        end

        train_feature_vector = features_all{curFeat}(train_set_inds,:);
        test_feature_vector = features_all{curFeat}(test_set_inds,:);


        X = single(train_feature_vector)';        
        Y = single(test_feature_vector)';

        % compute kernel
        [K K_test]= kernel(X,Y,parameterCell{curFeat}.kernelName,true);


        save('-v7.3',kernel_save_name, 'K');       

    else
        fprintf('Master Kernel %s already calculated.\n', get_kernel_filename(parameterCell{curFeat}));
    end
    disp('kernels are computed');
end


% toc
end
