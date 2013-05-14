function batch_FP_ADL_evaluation_stageful_only(videos,thres_range)
    
    avg_precision_list = [];
    avg_index = 1;
    effective_data = 0;
    for thres=thres_range
        
        precision_list = [];

        for i=videos
            fprintf('%d\n',i);

            %filename = ['FP_exp_1_vs_all_more_segment_2/result_' int2str(i) '.txt'];
            %filename = ['FP_exp_1_vs_all_more_segment_0409_error_in_stageful_data/result_' int2str(i) '.txt'];
            
            %filename = ['0410_FPN_300/no_pyramid/result_' int2str(i) '.txt'];
            filename = ['0410_FPN_300/more_segment_for_training/result_' int2str(i) '.txt'];
            
            precision = FP_ADL_evaluation_stageful_only(filename, i, thres);
            if precision ~= -1
                precision_list = [precision_list precision];
                effective_data = effective_data + 1;
            end

        end
        
        avg_precision = mean(precision_list);
        fprintf('Avg precision: %f \n',avg_precision);
        
        avg_precision_list = [avg_precision_list [thres;avg_precision]];
        
        avg_index = avg_index+1;
    end
    
    plot(avg_precision_list(1,:),avg_precision_list(2,:),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
    
    xlabel('Threshold');
    ylabel('Accuracy');
    
    fprintf('total avg precision: %f\n',mean(avg_precision_list(2,:)));
    effective_data
    
end