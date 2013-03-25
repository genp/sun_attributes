function [score_test,beta,b, err, err_test] = svm_one_vs_one_primal(K_train,K_test,class_train,class_test,lambda)
try
global K
K = K_train;
score_test = zeros(size(K_test,2), 1);
%train an SVM for each class, test against all test cases.

    Y = class_train; %pos = 1, neg = -1
    opt.cg = 1;
    [beta,b]=primal_svm(0, Y, lambda,opt);
    
     % test it on train
    score_train = K_train*beta+b;
    errs = score_train .* Y < 0 ;% neg if not agreeing, pos if same sign
    err  = mean(errs) ;
   
    % test it on test
    score_test(:,1) = K_test'*beta+b;
    errs_test = score_test .* class_test < 0 ;
    err_test  = mean(errs_test) ;
   
    fprintf('Train / Test error for lambda = %f: %f / %f \n', lambda, err, err_test);
catch
    disp('primal svm error');
%     keyboard
end
end
