%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Sets up global variables for running SUN Attributes code
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% make all the variables globals
global GVARS

GVARS.data_path = './';
GVARS.code_path = fullfile(GVARS.data_path, 'SUN_source_code_v2/code/');
GVARS.test_train_set_path = fullfile(GVARS.data_path, 'test_output/');
GVARS.kernel_path = fullfile(GVARS.data_path, 'data_v2/');

attributes_file = 'SUNAttributeDB/attributes.mat';
images_file = 'SUNAttributeDB/images.mat';
labels_file = 'SUNAttributeDB/attributeLabels_continuous.mat';

load(fullfile(GVARS.data_path, attributes_file));
load(fullfile(GVARS.data_path, images_file));
load(fullfile(GVARS.data_path, labels_file));
GVARS.attributes = attributes;
GVARS.images = images;
GVARS.labels_cv = labels_cv;
GVARS.train_set_save_name = fullfile(GVARS.test_train_set_path, 'train_set.mat');
GVARS.test_set_save_name = fullfile(GVARS.test_train_set_path, 'test_set.mat');
if(exist(GVARS.train_set_save_name, 'file'))

    load(GVARS.train_set_save_name);
    load(GVARS.test_set_save_name);
    GVARS.train_set_inds = train_set_inds;
    GVARS.test_set_inds = test_set_inds;
    GVARS.train_set = train_set;
    GVARS.test_set = test_set;
else
    disp('Train and test sets not pre-computed');
    return;
end

cd(GVARS.code_path);

