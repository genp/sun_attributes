% set up combined kernel params

function paraCombine = set_up_comb_kernel_params()
    %% combine kernel configuration
    n=0;
    n=n+1;
    paraCombine{n}.featureName  = 'all';
    paraCombine{n}.kernelName   = 'combine';
    paraCombine{n}.weighted     = false;
    paraCombine{n}.bow          = false;
    paraCombine{n}.normalize    = true;
    n=n+1;
    paraCombine{n}.featureName  = 'all';
    paraCombine{n}.kernelName   = 'combine';
    paraCombine{n}.weighted     = false;
    paraCombine{n}.bow          = false;
    paraCombine{n}.normalize    = false;
end