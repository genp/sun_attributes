%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Caculates AP score
% input - 
%   score_test: output confidences from the classifier. Values greater than
%   0.0 are considered positive detections.
%   test_labels: the ground truth labels. 1 is positive and -1 is negative
%   label. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ap ] = calc_ap( score_test, test_labels)
    [~,sort_inds] = sort(score_test, 'descend');
    tp = (test_labels > 0.999 & test_labels < 1.001);
    fp = (test_labels > -1.001 & test_labels < -0.9999);
    npos = numel(find(test_labels > 0.999 & test_labels < 1.001));
    tp = tp(sort_inds);
    fp = fp(sort_inds);
    fp=cumsum(fp);
    tp=cumsum(tp);
    rec=tp/npos;
    prec=tp./(fp+tp);

    ap=VOCap(rec,prec);
    if(isnan(ap))
        ap = 0.0;
    end


end

