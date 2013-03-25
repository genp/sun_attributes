%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute visual features on new image and saves to path
% feat_path/feat_name
%
% img_name: new image name, no extension
% feat_path : save path for features
% code_path : location of the feature functions (i.e. the SUN DB source
%               code path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calc_features(img_name, img_path, feat_path, code_path)

    conf.featNames   = {'hog2x2','gist','ssim','geo_color'} ;
    conf.featPath = feat_path;
    conf.imagePath = img_path;
    
    conf.geo_color.extractFn = @geo_color;
    conf.geo_color.classifiers=load(strcat(code_path, 'GeometricContext_dhoiem/data/ijcvClassifier.mat'));
    conf.geo_color.outside_quantization = false;
    
    conf.hog2x2.extractFn = @hog2x2;
    conf.hog2x2.interval = 8;
    conf.hog2x2.outside_quantization = true;
    conf.hog2x2.pyrLevels = 0:2;
    conf.hog2x2.format = 'dense';
    load(strcat(code_path, '../data/vocabulary/hog2x2_leq640.mat'));
    conf.hog2x2.textons = V;
    conf.hog2x2.vocabSize = size(V,2);

    conf.gist.extractFn            = @gist;
    conf.gist.imageSize            = 256;
    conf.gist.numberBlocks         = 4;
    conf.gist.fc_prefilt           = 4;
    conf.gist.G                    = createGabor([8 8 8 8], 256);
    conf.gist.outside_quantization = false;

    conf.ssim.extractFn         = @ssim ;
    conf.ssim.outside_quantization = true;
    conf.ssim.format            = 'dense' ;
    load(strcat(code_path, '../data/vocabulary/ssim_leq640.mat'));
    conf.ssim.textons = V;
    conf.ssim.vocabSize         = size(V,2);
    conf.ssim.pyrLevels         = 0:2 ;
    conf.ssim.coRelWindowRadius = 40 ;
    conf.ssim.subsample_x       = 4 ;
    conf.ssim.subsample_y       = 4 ;
    conf.ssim.numRadiiIntervals = 3 ;
    conf.ssim.numThetaIntervals = 10 ;
    conf.ssim.saliencyThresh    = 1 ;
    conf.ssim.size              = 5 ;
    conf.ssim.varNoise          = 150 ;
    conf.ssim.nChannels         = 3 ;
    conf.ssim.useMask           = 0 ;
    conf.ssim.autoVarRadius     = 1 ;
    

    extractFeature(img_name,conf);
end