function batch_FP_ADL_evaluation_stageful_only(videos,thres_range)
    
    avg_precision_list = [];
    avg_index = 1;
    for thres=thres_range
        
        precision_list = [];

        for i=videos
            fprintf('%d\n',i);

            filename = ['FP_exp_1_vs_all_more_segment/result_' int2str(i) '.txt'];
            precision = FP_ADL_evaluation_stageful_only(filename, i, thres);
            if precision ~= -1
                precision_list = [precision_list precision];
            end

        end
        
        avg_precision = mean(precision_list);
        fprintf('Avg precision: %f \n',avg_precision);
        
        
        %avg_precision_list(1,avg_index) = thres;
        %avg_precision_list(2,avg_index) = avg_precision;
        avg_precision_list = [avg_precision_list [thres;avg_precision]];
        
        avg_index = avg_index+1;
    end
    
    plot(avg_precision_list(1,:),avg_precision_list(2,:),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
    
    xlabel('Threshold');
    ylabel('Accuracy');
    
    fprintf('tatal avg precision: %f\n',mean(avg_precision_list(2,:)));
    
end