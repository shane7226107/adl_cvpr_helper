function batch_FP_ADL_evaluation_recall_precision(videos,thres_range)
    
    %filename = '0410_FPN_300/no_pyramid/result_';matfile='recall_precision_no_pyramid.mat';
    %filename = '0410_FPN_300/more_segment_for_training/result_';matfile='recall_precision_with_pyramid.mat';
    %filename = '0516_FPN_300/no_pyramid/result_';matfile='recall_precision_no_pyramid.mat';
    %filename = '0516_FPN_300/pyramid/result_';matfile='recall_precision_with_pyramid.mat';

    avg_precision_list = zeros(2,size(thres_range,2));
        
    avg_index = 1;
    for thres=thres_range
        
        precision_list = zeros(size(videos));

        for i=videos
            fprintf('%d\n',i);
            
            filepath = [filename int2str(i) '.txt'];
            precision_list(i) = FP_ADL_evaluation(filepath, i, thres);

        end
        
        avg_precision = mean(precision_list);
        fprintf('Avg precision: %f \n',avg_precision);
        
        
        avg_precision_list(1,avg_index) = thres;
        avg_precision_list(2,avg_index) = avg_precision;
        
        avg_index = avg_index+1;
    end

%%%%Recall   
 
    avg_recall_list = [];
    avg_index = 1;
    for thres=thres_range
        
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
        
        avg_index = avg_index+1;
    end

%%%%Save the mat file for function draw_recall_precision_both
    save(matfile,'avg_precision_list','avg_recall_list');
    
    
    plot(avg_recall_list(2,:),avg_precision_list(2,:),'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10)
    
    xlabel('Recall');
    ylabel('Precision');


    fprintf('tatal avg precision: %f\n',mean(avg_precision_list(2,:)));
    
end