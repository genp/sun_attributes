%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function generates a confidence for all attributes in a given image.
% 
% test_image : string for query image, expected extensions .jpg .png or
%               none
% image_kernel_save_path: the path to the location where the query kernels
%               should be saved.
% image_path : path to the test image
% image_feat_path : path to save the features for the test_image or where
%               the features are already saved
% classifier_path : location of attribute classifiers
%
% Need to execute these two commands before running classiy_attribute.
% These only need to be executed once per matlab session
%            addpath(genpath('PATH/TO/SUNAttribute_source_code/'));
%            vl_setup('noprefix');
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function confidence = classify_attribute(test_image, image_kernel_save_path, image_path, image_feat_path, classifier_path)
tic

% make all the variables globals
global GVARS
%Check that global variables have been loaded
try
    GVARS.attributes;
catch
    attributes_globals;
end

confidence = zeros(length(GVARS.attributes),1);

    %% combine kernel configuration
    paraCombine = set_up_comb_kernel_params();
    para = paraCombine{1};
    
    
    test_image = strrep(strrep(test_image, '.jpg', ''), '.png', '');
    %% calculate features for test_image
    calc_features(test_image, image_path, image_feat_path, GVARS.code_path);
    
    %% calculate the query kernel for this image
    K_query = calc_query_kernel(test_image, image_kernel_save_path, image_feat_path);
    
for a_ind = 1:length(GVARS.attributes)
    writable_attribute = strrep(strrep(GVARS.attributes{a_ind}, ' ', '_'), '/', '');
    %TODO fix this detail...
    attribute_classifier_path = fullfile(classifier_path,writable_attribute);
    [train_inds,train_labels,test_inds,test_labels,ratio,ratio_test] = load_test_train_sets(a_ind, false);
    
    reg_const = 1.0;
    %% combine kernel configuration
    % subsample K_query for the train set inds for this attribute
    [temp K_query_test] = kernel_subsample(train_inds, [1], K_query, true);
    
    % load combined normalized kernel SVM model
    combined_model_save_name = fullfile(attribute_classifier_path, ...
        sprintf('%s_size%d_ratio%s_regconst%s_%s','SVM_Model', ...
        length(train_inds), ...
        strrep(sprintf('%2.3f',ratio*100),'.','pt'), ...
        strrep(sprintf('%f',reg_const),'.','pt'), ...
        get_kernel_filename(para)));
    if(~exist(combined_model_save_name,'file')) 
       disp('Combined kernel SVM model not pre-computed! Please do that!');    
       return;
    end
    beta = [];    
    load(combined_model_save_name);
    confidence(a_ind,1) = K_query_test'*beta+b;
    
    % print results (ap avg over splits, accuracy on val set.)
    fprintf('The confidence score for %s is %f \n',  GVARS.attributes{a_ind}, confidence(a_ind,1));


end
t = toc;
fprintf('All attribute confidences calculated. Time elapsed: %f\n',t);
end
