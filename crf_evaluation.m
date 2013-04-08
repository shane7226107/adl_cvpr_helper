function [avg_accuracy confusion_matrix]= crf_evaluation(filename)
    fprintf('crf_evaluation\n');
    num_class = 16;
    lines = read(filename);
    
    acc_counter = 0;
    confusion_matrix = zeros(num_class,num_class);
    
    num_lines = size(lines{1},1);
    
    for i=1:num_lines
        fprintf('%d : %s %s\n',i,lines{1,90}{i},lines{1,91}{i});
        
        str1 = lines{1,90}{i};
        str2 = lines{1,91}{i};
        
        [source target] = con_matrix(str1,str2);
        confusion_matrix(source,target) = confusion_matrix(source,target) + 1;
        
        if strcmp(str1,str2)
            acc_counter = acc_counter + 1;
        end
    end
    
    avg_accuracy = acc_counter/num_lines;
    
    fprintf('accuracy: %f\n', avg_accuracy);
end

function lines = read(file_name)
    f_id = fopen(file_name);
    % I know it is stupid...
    lines = textscan(f_id,'%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %s %s');
    
    fclose all;
end

function [source target] = con_matrix(str1,str2)
            
action_list = {
            'combing_hair'
            'make_up'
            'brushing_teeth'
            'dental_floss'
            'washing_hands_face'
%           'drying_hands_face'
%             'enter_leave_room'
%             'adjusting_thermostat'
            'laundry'
            'washing_dishes'
            'moving_dishes'
            'making_tea'
            'making_coffee'
            'drinking_water_bottle'
            'drinking_water_tap'
%             'making_hot_food'
%             'making_cold_food_snack'
%             'eating_food_snack'
%             'mopping_in_kitchen'
            'vacuuming'
%             'taking_pills'
            'watching_tv'
            'using_computer'
            'using_cell'
%             'making_bed'
%             'cleaning_house'
%             'reading_book'
%             'using_mouth_wash'
%             'writing'
%             'putting_on_shoes_socks'
%             'drinking_coffee_tea'
%             'grabbing_water_from_tap'
    };
    
    for i=1:size(action_list,1)
        S = regexp(str1, '_stage_', 'split');
        source = find(strcmp(action_list,S{1}));
        
        S = regexp(str2, '_stage_', 'split');
        target = find(strcmp(action_list,S{1}));
    end
end