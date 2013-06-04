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
       
       result_pyramid = result_read(test_video,1);
       
%        precision_list = [];
%        recall_list = [];
%        
%        for action=1:size(action_list,2)
%             action_name = action_list{action};
%             [precision,recall] = action_evaluation(result,action_name);
%             
%             if precision ~= -1 && recall ~= -1
%                 precision_list = [precision_list precision];
%                 recall_list = [recall_list recall];
%             end
%        end             
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

function [precision,recall] = action_evaluation(result,action_name)    
    
    tp = 0;
    fp = 0;
    tn = 0;
    fn = 0;
    
    for line=1:size(result{1},1)
        
        truth = result{22}{line};
        prediction = result{23}{line};
        
        %fprintf('%s %s\n',truth,prediction);      
        
        if strcmp(truth,action_name)           
            if strcmp(truth,prediction)
                tp = tp + 1;
            else
                fn = fn + 1;
            end
        else
            if strcmp(action_name,prediction)
                fp = fp + 1;
            else
                tn = tn + 1;
            end
        end
        
    end
    
    if (tp+fp) == 0 || (tp+fn) == 0
        precision = -1;
        recall = -1;
    else
        precision = tp/(tp+fp);
        recall = tp/(tp+fn);   
    end    
    
end
