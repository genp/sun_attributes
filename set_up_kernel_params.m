% set up kernel parameters

function parameterCell = set_up_kernel_params()
    %% kernel configuration
    n = 0;
    % 'gist'
    n=n+1;
    parameterCell{n}.featureName  = 'gist';
    parameterCell{n}.kernelName   = 'echi2';
    parameterCell{n}.weighted     = false;
    parameterCell{n}.bow          = false;
    parameterCell{n}.normalize    = false;

    % 'hog2x2'

    n=n+1;
    parameterCell{n}.featureName  = 'hog2x2';
    parameterCell{n}.kernelName   = 'kl1';
    parameterCell{n}.weighted     = true;
    parameterCell{n}.bow          = false;
    parameterCell{n}.normalize    = false;

    % 'ssim'
    n=n+1;
    parameterCell{n}.featureName  = 'ssim';
    parameterCell{n}.kernelName   = 'echi2';
    parameterCell{n}.weighted     = false;
    parameterCell{n}.bow          = false;
    parameterCell{n}.normalize    = false;


    % 'geo_color'

    n=n+1;
    parameterCell{n}.featureName  = 'geo_color';
    parameterCell{n}.kernelName   = 'kchi2';
    parameterCell{n}.weighted     = false;
    parameterCell{n}.bow          = false;
    parameterCell{n}.normalize    = false;
end