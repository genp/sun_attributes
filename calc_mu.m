%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Calculates mu value for feature kernels of type echi2. This is needed
% when computing test kernels for classifying attributes in novel images.
% See test_kernel.m for use location.
% 
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function calc_mu(X, save_name)
    
    %vl_setup('noprefix');
    disp('Calculating mu value...');
    K = alldist2(X, 'chi2') ;
    mu= 1 ./ mean(K(:)) ;
    save(save_name, 'mu');

end
