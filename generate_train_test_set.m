%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Generates randomly selected train/ test set from the SUN Attribute dataset
%
% test_percentage : percent of the dataset to put in the test set range -
%                   0-1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function generate_train_test_set(test_percentage)

    % make all the variables globals
    global GVARS
    %Check that global variables have been loaded    
try
    GVARS.attributes;
catch
    attributes_globals;
end
    
    train_set_save_name = fullfile(GVARS.test_train_set_path, 'train_set.mat');
    test_set_save_name = fullfile(GVARS.test_train_set_path, 'test_set.mat');

    if(~exist(train_set_save_name, 'file') || ~exist(test_set_save_name, 'file'))
        test_set_size = length(GVARS.images)*test_percentage;
        test_set_inds = randperm(length(GVARS.images), test_set_size);
        test_set = GVARS.images(test_set_inds);

        train_set_inds = ones(length(GVARS.images),1);
        train_set_inds( test_set_inds) = 0;
        train_set_inds = find(train_set_inds == 1);
        train_set = GVARS.images(train_set_inds);


        save(train_set_save_name, 'train_set', 'train_set_inds');
        save(test_set_save_name, 'test_set', 'test_set_inds');
    end
end
