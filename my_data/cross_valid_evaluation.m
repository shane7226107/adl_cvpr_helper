function cross_valid_evaluation()
    
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
        
       result = result_read(test_video);
       
       for action=1:size(action_list,2)
            action_name = action_list{action};
            [precision,recall] = action_evaluation(result,action_name);
            fprintf('precision : %f \n recall : %f \n', precision,recall);
       end
    end

end

function result = result_read(index)    
    
    filename = sprintf('cross_valid_result/result_%02d.txt',index);
    
    fprintf('reading: %s\n', filename);
    
    fid = fopen(filename);
    %0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	drink_water	drink_water
    result = textscan(fid, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %s %s');
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
        
        fprintf('%s %s\n',truth,prediction);       
       
        
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
