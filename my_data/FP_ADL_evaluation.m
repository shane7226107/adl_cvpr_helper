function FP_ADL_evaluation()
    
    global action_list 
    action_list = {          
        'use_computer'
        'use_cell'
        'wash_hand'
        'drink_water'
        'talk_to_people'
        'check_the_weather'
        'reading'
        'making_coffee_stage_1'
        'making_coffee_stage_2'
        'copy_documents_stage_1'
        'copy_documents_stage_2'        
    };
    action_list = action_list';
    
    for test_video=1:5
        
       action_annotation = action_annotation_read(test_video);       
       
       result_no_pyramid = result_read(test_video,0);
       
       %result_pyramid = result_read(test_video,1);       
       
       precision_list = [];
       recall_list = [];
       
       for action=1:11
           action_name = action_list{action}
       end

       
%      fprintf('video %d \n avg precision : %f \n avg recall : %f \n', test_video,mean(precision_list),mean(recall_list));

       
    end

end

function result = result_read(index,pyramid)    
    
    if(pyramid)
        filename = sprintf('FP_ADL_result/pyramid/result_%02d.txt',index);
    else
        filename = sprintf('FP_ADL_result/no_pyramid/result_%02d.txt',index);
    end
    
    fprintf('reading: %s\n', filename);
    
    fid = fopen(filename);
    %1 use_cell 0.890130
    result = textscan(fid, '%d %s %f');
    %Usage:
    %obj_anno{col}(row)
    %obj_anno{7}(1)
    fclose(fid);
    fprintf('finished reading FP_ADL_result file\n');
end

function action_annotation = action_annotation_read(index)    
    
    filename = sprintf('annotations/action/P%02d.txt',index);
    
    fprintf('reading: %s\n', filename);
    
    fid = fopen(filename);
    %001021 001351 4 drink_water
    action_annotation = textscan(fid, '%d %d %d %s');
    %Usage:
    %obj_anno{col}(row)
    %obj_anno{7}(1)
    fclose(fid);
    fprintf('finished reading action annotation file\n');
end

% function [precision,recall] = action_evaluation(result,action_name,action_annotation,thres)
%     
%     tp = 0;
%     fp = 0;
%     tn = 0;
%     fn = 0;
% 
%     for line=1:size(result{1},1)
%         
%         frame = result{1}(line);
%         prediction = result{2}{line};        
%         prob = result{3}(line);
%         
%         if prob >= thres && strcmp(prediction,action_name)
%             
%             true = -1;
%             
%             for i=1:size(action_annotation{1},1)
%                 start_frame = action_annotation{1}(i);
%                 end_frame = action_annotation{2}(i);
%                 ground_truth = action_annotation{4}{i};
%                 
%                 if frame >= start_frame && frame <= end_frame && strcmp(action_name, ground_truth)
%                     true = 1;
%                     break;
%                 end
%             end
%             
%             if true == 1
%                 tp = tp + 1;
%             else
%                 fp = fp + 1;
%             end
%         else
%             true = 1;
%             
%             for i=1:size(action_annotation{1},1)
%                 start_frame = action_annotation{1}(i);
%                 end_frame = action_annotation{2}(i);
%                 ground_truth = action_annotation{4}{i};
%                 
%                 if frame >= start_frame && frame <= end_frame && strcmp(action_name, ground_truth)
%                     true = -1;
%                     break;
%                 end
%             end
%             
%             if true == 1
%                 tn = tn + 1;
%             else
%                 fn = 1;
%             end
%         end
%         
%     end   
%     
%     
%     precision = tp/(tp+fp);
%     recall = tp/(tp+fn);   
%     
%     
% end
