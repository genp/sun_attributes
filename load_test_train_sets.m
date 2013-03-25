%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Loads the appropriate train and test set indicies for the given attribute
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [train_inds,train_labels,test_inds,test_labels,ratio,ratio_test] = load_test_train_sets(attr_ind, include1votes)


% make all the variables globals
global GVARS
%Check that global variables have been loaded
try
    GVARS.attributes;
catch
    attributes_globals;
end

    if(include1votes)
        up_bound = 0.5;
        low_bound = 0.5;
    else
        up_bound = 0.6;
        low_bound = 0.01;
    end
    
    attr_labels = GVARS.labels_cv(:,attr_ind);  
    pos_inds = attr_labels > up_bound;
    neg_inds = attr_labels <= low_bound;
    
    all_zeros = zeros(1,14340);
    train_ones = all_zeros;
    train_ones(GVARS.train_set_inds) = 1;
    test_ones = all_zeros;
    test_ones(GVARS.test_set_inds) = 1;
    pos_ones = all_zeros;
    pos_ones(pos_inds) = 1;
    neg_ones = all_zeros;
    neg_ones(neg_inds) = 1;  
        
    pos_inds_train = find(pos_ones & train_ones);
    neg_inds_train = find(neg_ones & train_ones);
    pos_inds_test = find(pos_ones & test_ones);
    neg_inds_test = find(neg_ones & test_ones);

    ratio = length(pos_inds_train)/(length(pos_inds_train)+length(neg_inds_train));
    ratio_test = length(pos_inds_test)/(length(pos_inds_test)+length(neg_inds_test));
    train_labels = vertcat(ones(length(neg_inds_train),1).*-1, ones(length(pos_inds_train),1));
    test_labels = vertcat(ones(length(neg_inds_test),1).*-1, ones(length(pos_inds_test),1));

    train_inds = horzcat(neg_inds_train, pos_inds_train);
    test_inds = horzcat(neg_inds_test, pos_inds_test); 
end
