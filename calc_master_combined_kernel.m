%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is for calculating the test and train combined kernel from the 
% whole dataset.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function calc_master_combined_kernel(save_path)

% make all the variables globals
global GVARS
%Check that global variables have been loaded
try
    GVARS.attributes;
catch
    attributes_globals;
end
%% kernel configuration
parameterCell = set_up_kernel_params();
%% combine kernel configuration
paraCombine = set_up_comb_kernel_params();

%% test/train set
train_set_inds = single(1:length(GVARS.images));    

%% weighting - averaging

for i=1:length(parameterCell)
    parameterCell{i}.weight = 1;
    
end
%% Repeat above
% combine kernel and svm
disp('combining kernels ...');
nLengCombine = length(paraCombine);

for j=1:nLengCombine
    para = paraCombine{j};
    comb_kernel_save_name = fullfile(save_path, sprintf('%s_kernel_size%d_%s','Combined_Master', length(train_set_inds), get_kernel_filename(para)));
    
        
    if(~exist(comb_kernel_save_name,'file')) 
            
        for i=1:length(parameterCell)
            mu(i) = 1;
            % load corresponding kernels
            kernel_save_name = fullfile(save_path, sprintf('%s_kernel_size%d_%s','Train', length(train_set_inds), get_kernel_filename(parameterCell{i})));
            
            if(~exist(kernel_save_name,'file'))
                disp('Some feature kernels missing, please compute them before running this script.');
                return;
            end
            load(kernel_save_name);
            
            if para.normalize
                mu(i) = mean(mean(K));
            end
            if i==1
                K_comb = parameterCell{i}.weight * (K/mu(i));
            else
                K_comb = K_comb + parameterCell{i}.weight * (K/mu(i));
            end
        end

        K=K_comb;
        save(comb_kernel_save_name,'-v7.3','K');
    end


end
disp('Kernels combined!');

end
