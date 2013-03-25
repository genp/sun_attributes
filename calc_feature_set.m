%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Calculates an array of the feature vector for each image in the SUN
% Attribute dataset for all of the features used (hog2x2, gist,
% self-similarity, and geometric color histogram)
%
% img_path : path to images
% feat_path : path to the pre-computed features for the SUN Attribute
%               images or the location where the features should be stored
%               when they are calculated
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function calc_feature_set(img_path,feat_path)

% make all the variables globals
global GVARS
%Check that global variables have been loaded
try
    GVARS.attributes;
catch
    attributes_globals;
end
    
    parameterCell = set_up_kernel_params();
    
    for curFeat = 1:length(parameterCell)
        features_all{curFeat} = [];
        feature_save_file_name = fullfile(GVARS.test_train_set_path, ...
            sprintf('%s_image_features.mat',parameterCell{curFeat}.featureName));
        fprintf('Calculating file %s ...\n',feature_save_file_name);
        if(exist(feature_save_file_name,'file'))
            fprintf('This file already exists : %s\n',feature_save_file_name);
        else
            image_feature_paths = cellfun(@(name) strrep(name, '.jpg', '.mat'),...
            cellfun(@(img) fullfile(feat_path, parameterCell{curFeat}.featureName, img),GVARS.images,...
            'UniformOutput', false), 'UniformOutput', false);

            for cnt = 1:length(GVARS.images)
                feat_fname = image_feature_paths{cnt};
                try
                    F(cnt) = {load(feat_fname)};            
                catch 
                    fprintf('Image %s feature is being calculated: %s\n',GVARS.images{cnt}, feat_fname);
                    calc_features(strrep(strrep(GVARS.images{cnt}, '.jpg',''),'.png',''), img_path, feat_path, GVARS.code_path); 
                    F(cnt) = {load(feat_fname)};
                end
            end
            feature_vector = packF(F,...
                            parameterCell{curFeat}.featureName,...
                            parameterCell{curFeat}.weighted,...
                            parameterCell{curFeat}.bow,...
                            parameterCell{curFeat}.normalize)';
            clear F;
            features_all{curFeat} = feature_vector;
            save(feature_save_file_name,'feature_vector');
        end
    end
end
