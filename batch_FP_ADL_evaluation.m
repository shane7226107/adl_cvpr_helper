function batch_FP_ADL_evaluation(videos,thres_range)
    
    avg_precision_list = zeros(2,size(thres_range,2));
        
    avg_index = 1;
    for thres=thres_range
        
        precision_list = zeros(size(videos));

        for i=videos
            fprintf('%d\n',i);

            %filename = ['FP_exp_1_vs_all_more_segment_2/result_' int2str(i) '.txt'];
            filename = ['FP_exp_1_vs_all_more_segment_0409_error_in_stageful_data/result_' int2str(i) '.txt'];
            
            precision_list(i) = FP_ADL_evaluation(filename, i, thres);

        end
        
        avg_precision = mean(precision_list);
        fprintf('Avg precision: %f \n',avg_precision);
        
        
        avg_precision_list(1,avg_index) = thres;
        avg_precision_list(2,avg_index) = avg_precision;
        
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