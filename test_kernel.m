% if are using echi2 or emd or rbf, need to provide a mu
function [K_test]= test_kernel(X, Y, kernelName, mu)

if (~exist('mu','var') && ( strcmp(kernelName,'echi2')==1 ))
 disp('Need to provide mu value for test_kernel echi2 type calculation. mu = 1./mean(K) where K is the chi2 kernel of distances between elements of X.');
 K_test = [];
 return;
end

switch kernelName

    case 'echi2'
        K_test = vl_alldist(X, Y, 'chi2') ;
        K_test = exp(- mu * K_test) ;
    case 'kl1' %hist_intersect
        K_test = vl_alldist2(X, Y, 'kl1');
    case'kl2'
        K_test = X' * Y ;
    case 'kchi2'
        K_test = vl_alldist2(X, Y, 'kchi2') ;


end

if ~isempty(find(isnan(K_test)))
    disp('something element is NaN in the K_test matrix');
    K_test(find(isnan(K_test)))=10^20;
end