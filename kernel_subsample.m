%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the kernel subsampling function. It takes the indicies of the
% examples to be included in the new kernel and outputs a new kernel
% that only has those examples included. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [K K_test] = kernel_subsample(train_inds, test_inds, master_kernel, test_kernel_only)
K = [];

% get all K values - all affinities from train_inds to each other
if(~exist('test_kernel_only','var') || ~test_kernel_only)
    K = master_kernel(train_inds, train_inds);
end

% get all K_test values - all affinities from train_inds to each other
K_test = master_kernel(train_inds, test_inds);


end