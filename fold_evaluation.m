fold = 5;
score = [];

for i = 1:fold
    %score = [score crf_evaluation(['cross_valid/result/unigram/fold_' int2str(i) '_result.txt'])];
    score = [score crf_evaluation(['cross_valid_complex/result/bigram/fold_' int2str(i) '_result.txt'])];
end

avg = mean(score)

plot([score avg],'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
