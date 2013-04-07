fold = 5;
avg_accuracy_total = [];
confusion_matrix_total = zeros(32,32);

for i = 1:fold
    %avg_accuracy = [avg_accuracy crf_evaluation(['cross_valid/result/unigram/fold_' int2str(i) '_result.txt'])];
    [avg_accuracy confusion_matrix]= crf_evaluation(['cross_valid_complex/result/bigram/fold_' int2str(i) '_result.txt']);
    avg_accuracy_total = [avg_accuracy_total avg_accuracy];
    confusion_matrix_total = confusion_matrix_total + confusion_matrix;
end

avg = mean(avg_accuracy_total)

plot([avg_accuracy_total avg],'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
