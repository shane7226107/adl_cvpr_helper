function action_observation_to_crf( sample_set, fold)
    
    if nargin < 1
        sample_set = 1:20;
    end
    
    if nargin < 2
        fold = 5;
    end


    load('action_observation_counter.mat');
    load('action_observation_table.mat');    
    
    indices = crossvalind('Kfold',size(sample_set,2),fold)';
    
    for i=1:fold
              
        %testing data indices
        test_set = find(indices==i);
        
        %training data indeices
        train_set = find(indices~=i);
        
        %producing testing data
        str = ['cross_valid/fold_' int2str(i) '_testing.txt'];
        output_crf_data(str , test_set , action_observation_table, action_observation_counter);
        
        %producing training data
        str = ['cross_valid/fold_' int2str(i) '_training.txt'];
        output_crf_data(str , train_set , action_observation_table, action_observation_counter);
        
    end
    
end

function output_crf_data(filename,sample_set,action_observation_table,action_observation_counter)

    
    chosen_actions = [1 2 3 4 5 6 9 10 11 12 13 14 15 17 20 22 23 24];
   
    
    action_list = {
        'combing_hair'
        'make_up'
        'brushing_teeth'
        'dental_floss'
        'washing_hands_face'
        'drying_hands_face'
        'enter_leave_room'
        'adjusting_thermostat'
        'laundry'
        'washing_dishes'
        'moving_dishes'
        'making_tea'
        'making_coffee'
        'drinking_water_bottle'
        'drinking_water_tap'
        'making_hot_food'
        'making_cold_food_snack'
        'eating_food_snack'
        'mopping_in_kitchen'
        'vacuuming'
        'taking_pills'
        'watching_tv'
        'using_computer'
        'using_cell'
        'making_bed'
        'cleaning_house'
        'reading book'
        'using_mouth_wash'
        'writing'
        'putting_on_shoes_sucks'
        'drinking_coffee_tea'
        'grabbing_water_from_tap'
    };
    

    f_out_id = fopen(filename,'w');
    
    for action=chosen_actions
        
        fprintf('action %d \n',action);
        feature_sum = zeros(1,90);
        
        for i=1:action_observation_counter(1,action)
            
            features = action_observation_table(i,:,action);
            
            if ~isempty(find(sample_set==features(90), 1))
                fprintf('video %d, belongs to the sample set\n',features(90));
                             
                feature_sum = feature_sum + features;
                
                for f=1:89
                    fprintf(f_out_id,'%d ',features(f));
                end
                
                fprintf(f_out_id,'%s\n\n',action_list{action});
                
            else
                continue;
            end
        end
        
        %plot(feature_sum(1:89));
        %k = waitforbuttonpress;
        
    end
    
    close all;
    fclose all;
end