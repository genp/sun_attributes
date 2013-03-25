%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for calculating the attribute specific combined feature kernels
% for a query image
%
% test_img : string of test image name, no extension
% save_path : place to save computed kernel
% img_feat_path : path to the pre-computed feature directory, expecting
%               format of SUN database source code for pre-computed
%               features, e.x. 'img_feat_path/hog2x2/test_img.mat'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function K_query = calc_query_kernel(test_img, save_path, img_feat_path)
  

% make all the variables globals
global GVARS
%Check that global variables have been loaded
try
    GVARS.attributes;
catch
    attributes_globals;
end
        
    if(~exist(save_path,'dir'))
       mkdir(save_path); 
    end

    %% kernel configuration
    parameterCell = set_up_kernel_params();
   
    %% calculate per feature kernels
    comb_kquery_save_name = fullfile(save_path, sprintf('combined_kernel_%s.mat', strrep(test_img, '/','_')));    
    tic
%Check if precomputed    
if(~exist(comb_kquery_save_name,'file')) 
    for curFeat = 1:length(parameterCell)

        % recalculate kernel
        % load, pack, save features for all images first
        features_all{curFeat} = [];
        feature_save_file_name = fullfile(GVARS.kernel_path, ...
            sprintf('%s_image_features.mat',parameterCell{curFeat}.featureName));
        if(exist(feature_save_file_name,'file'))
            load(feature_save_file_name);
            features_all{curFeat} = feature_vector;
        else
               disp('Need to pre-compute features!');
               return;
        end


        fprintf('Calculating kernel : %s \n For test image : %s ... \n', get_kernel_filename(parameterCell{curFeat}), test_img);
        train_feature_vector = features_all{curFeat};

        X = single(train_feature_vector)';  

        image_feature_path = fullfile(img_feat_path, parameterCell{curFeat}.featureName, [test_img '.mat']);
        try
            F = {load(image_feature_path)};            
        catch 
            fprintf('Image %s feature cannot be loaded: %s\n',test_img, image_feature_path);
            K_query = [];
            return;
        end

        img_feature_vector = packF(F,...
                        parameterCell{curFeat}.featureName,...
                        parameterCell{curFeat}.weighted,...
                        parameterCell{curFeat}.bow,...
                        parameterCell{curFeat}.normalize)';


        Y = single(img_feature_vector)';

        % load the master kernel for this feature and compute mu


        if(strcmp(parameterCell{curFeat}.kernelName, 'echi2'))
            mu_save_name = fullfile(GVARS.test_train_set_path, ...
                          sprintf('mu_kernel_size%d_%s',length(GVARS.images),get_kernel_filename(parameterCell{curFeat})));
            if(~exist(mu_save_name, 'file'))
                calc_mu(X, mu_save_name);
            end                      
            load(mu_save_name);
            mu_all(curFeat) = mu;
            clear mu
        else
            mu_all(curFeat) = 1;
        end
        clear K
        % compute kernel
        [K_q{curFeat}]= test_kernel(X, Y, parameterCell{curFeat}.kernelName, mu_all(curFeat));

    end    
    disp('combining kernels ...');
    for i=1:length(parameterCell)
        %this corresponds to normalizing the combined kernel
        mu(i) = mean(mean(K_q{i}));

        %averaging and normalizing the input kernels 
        if i==1
            K_query = 1 * (K_q{i}/mu(i));
        else
            K_query = K_query + 1 * (K_q{i}/mu(i));
        end
    end


    save('-v7.3',comb_kquery_save_name, 'K_query');
        
else
    fprintf('Kernel %s  already calculated.\n', comb_kquery_save_name);
    load(comb_kquery_save_name);
end
    disp('kernel is computed');

end
