function batch_FP_ADL_evaluation_recall_precision(videos,thres_range)
    
    %filename = '0410_FPN_300/no_pyramid/result_';matfile='recall_precision_no_pyramid.mat';
    %filename = '0410_FPN_300/more_segment_for_training/result_';matfile='recall_precision_with_pyramid.mat';
    %filename = '0516_FPN_300_dpm_thres_0.7/no_pyramid/result_';matfile='recall_precision_no_pyramid.mat';
    %filename = '0516_FPN_300_dpm_thres_0.7/pyramid/result_';matfile='recall_precision_with_pyramid.mat';
    %filename = '0520_FPN_300_dpm_thres_0.75/no_pyramid/result_';matfile='recall_precision_no_pyramid.mat';
    filename = '0520_FPN_300_dpm_thres_0.75/pyramid/result_';matfile='recall_precision_with_pyramid.mat';
    

    avg_precision_list = [];
        
    precision_end_index = 1;
    for thres=thres_range
        
        precision_list = [];

        for i=videos
            fprintf('%d\n',i);
            
            filepath = [filename int2str(i) '.txt'];
            precision = FP_ADL_evaluation(filepath, i, thres);
            if precision ~= -1
                precision_list = [precision_list precision];
            end

        end
        
        if size(precision_list,2) > 0
            avg_precision = mean(precision_list);
        else
            %Break out if the precision reaches boundary at this threshold
            break;
        end
        
        
        
        fprintf('Avg precision: %f \n',avg_precision);
        
        avg_precision_list = [avg_precision_list [thres;avg_precision]];
        
        precision_end_index = precision_end_index+1;
    end

%%%%Recall   
 
    avg_recall_list = [];
    recall_avg_index = 1;
    for thres=thres_range
        
        %Break out if the precision reaches boundary at this threshold
        if recall_avg_index == precision_end_index
            break;
        end
        
        recall_list = [];

        for i=videos
            fprintf('%d\n',i);
            
            filepath = [filename int2str(i) '.txt'];
            recall = FP_ADL_evaluation_recall(filepath, i, thres);
            if recall ~= -1
                recall_list = [recall_list recall];
            end

        end
        
        avg_recall = mean(recall_list);
        fprintf('Avg recall: %f \n',avg_recall);
        
        avg_recall_list = [avg_recall_list [thres;avg_recall]];
        
        recall_avg_index = recall_avg_index+1;
    end

%%%%Save the mat file for function draw_recall_precision_both
    save(matfile,'avg_precision_list','avg_recall_list');
    
    if ~isempty(avg_precision_list) && ~isempty(avg_recall_list)
        plot(avg_recall_list(2,:),avg_precision_list(2,:),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
    
        xlabel('Recall');
        ylabel('Precision');


        fprintf('\n============\ntotal avg precision: %f\n',mean(avg_precision_list(2,:)));
        fprintf('total avg recall: %f\n',mean(avg_recall_list(2,:)));
    else
        fprintf('Not enough data for drawing the curve!\n');
    end
    
    
    
end