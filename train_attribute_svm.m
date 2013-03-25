%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This trains the non-linear SVMs for each feature and the combined feature
% for the input attribute.
%
% Loads the pre-calculated test/train kernels
%
% a_ind: index of the desired attribute 
% reg_const: the regularization constant to use with the SVM
% save_path : directory under which to save the learned classifier
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function train_attribute_svm(a_ind, reg_const, save_path)

% make all the variables globals
global GVARS
%Check that global variables have been loaded
try
    GVARS.attributes;
catch
    attributes_globals;
end

writable_attribute = strrep(strrep(GVARS.attributes{a_ind}, ' ', '_'), '/', '');

% save model in a subfolder named for the attribute.
if(~exist(save_path,'dir'))
   mkdir(save_path,writable_attribute);
end
save_path = fullfile(save_path,writable_attribute);
%% kernel configuration
parameterCell = set_up_kernel_params();

%% combine kernel configuration
paraCombine = set_up_comb_kernel_params();


%% test/train set

  % Positive Labels have confidence > 0.6 and Negative Labels < 0.01
  [train_inds,train_labels,test_inds,test_labels,ratio,ratio_test] = load_test_train_sets(a_ind, false);

%% weighting - using accuracy

    for i=1:length(parameterCell)
        parameterCell{i}.weight = 1;

    end

 
    for j=1
        para = paraCombine{j};

        % train combined kernel svm   
        combined_model_save_name = fullfile(save_path, sprintf('%s_size%d_ratio%s_regconst%s_%s','SVM_Model', length(train_inds), strrep(sprintf('%2.3f',ratio*100),'.','pt'), strrep(sprintf('%f',reg_const),'.','pt'), get_kernel_filename(para)));


        if(~exist(combined_model_save_name,'file'))
            clear libsvm_cl score_test beta b err_train err_test

            % load corresponding kernels

            comb_kernel_name = fullfile(GVARS.kernel_path, sprintf('Combined_Master_kernel_size%d_%s',length(GVARS.images), get_kernel_filename(para)));
            load(comb_kernel_name);
            master_kernel = K;
            clear K
            [K K_test] = kernel_subsample(train_inds, test_inds, master_kernel);

            [score_test,beta,b,err_train, err_test] = svm_one_vs_one_primal(K,K_test,train_labels,test_labels,reg_const);
            
            ap = calc_ap(score_test, test_labels);

            save('-v7.3',combined_model_save_name, 'beta','b','score_test','err_train','err_test','ap'); 
            % print results (ap avg over splits, accuracy on val set.)
            fprintf('The AP score for the %s SVM for %s is %f \n',  get_kernel_filename(para), GVARS.attributes{a_ind}, ap);


        else
            disp('This model already calculated.');
            return;

        end

    end

toc
end
