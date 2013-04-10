function action_observation_to_crf_1_vs_all_more_segment()
 
    
    load('action_observation_counter.mat');
    load('action_observation_table.mat');
    
    load('action_observation_counter_complex.mat');
    load('action_observation_table_complex.mat');
    
    
    action_observation_counter(1,9) = action_observation_counter_complex(1,9);
    action_observation_counter(1,12) = action_observation_counter_complex(1,12);
    action_observation_counter(1,13) = action_observation_counter_complex(1,13);
    action_observation_counter(1,16) = action_observation_counter_complex(1,16);
    
    action_observation_table(:,:,9) = action_observation_table_complex(:,:,9);
    action_observation_table(:,:,12) = action_observation_table_complex(:,:,12);
    action_observation_table(:,:,13) = action_observation_table_complex(:,:,13);
    action_observation_table(:,:,16) = action_observation_table_complex(:,:,16);

    
    for i=1:20
              
        %testing data indices
        test_set = [i]
        
        %training data indeices
        train_set = [1:i-1 i+1:20]
        
        %producing testing data
        str = ['cross_valid_1_vs_all_AO/' int2str(i) '_testing.txt'];
        output_crf_data(str , test_set , action_observation_table, action_observation_counter);
        
        %producing training data
        str = ['cross_valid_1_vs_all_AO/' int2str(i) '_training.txt'];
        output_crf_data(str , train_set , action_observation_table, action_observation_counter);
        
    end
    
end

function output_crf_data(filename,sample_set,action_observation_table,action_observation_counter)
    
    chosen_actions = [1 2 3 4 5 6 9 10 11 12 13 14 15 16 17 20 22 23 24];
   
    
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
        'putting_on_shoes_socks'
        'drinking_coffee_tea'
        'grabbing_water_from_tap'
    };
    
    f_out_id = fopen(filename,'w');
    f_out_id_2 = fopen([filename '_indices.txt'],'w');
    
    for i=sample_set
        fprintf(f_out_id_2,'%d ',i);
    end
    
    for action=chosen_actions
        
        fprintf('action %d \n',action);
        
        for i=1:action_observation_counter(1,action)
            
            stage = action_observation_table(i,91,action);
            
            features = action_observation_table(i,1:90,action);
            
            if ~isempty(find(sample_set==features(90), 1))
                
                fprintf('video %d, belongs to the sample set\n',features(90));                             
                
                %Single stage or multi stage
                if stage == 0 || stage == 1
                   fprintf(f_out_id,'\n');
                end
                
                %passive features
                for f=1:46
                    if features(f) > 0
                        fprintf(f_out_id,'%d ',1);
                    else
                        fprintf(f_out_id,'%d ',0);
                    end
                end
                
                %active feature
                max_AO=0;
                max_score=0;
                for f=47:89
                    if features(f) > max_score
                        max_AO = f;
                        max_score = features(f);
                    end
                end
                fprintf(f_out_id,'%d ',max_AO);
                
                
                if stage == 0
                   fprintf(f_out_id,'%s\n',action_list{action}); 
                else
                   action_name = [action_list{action} '_stage_' int2str(stage)];
                   fprintf(f_out_id,'%s\n',action_name);
                end                
                
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

% 1 : bed
% 2 : book
% 3 : bottle
% 4 : cell
% 5 : dent_floss
% 6 : detergent
% 7 : dish
% 8 : door
% 9 : fridge
% 10 : kettle
% 11 : laptop
% 12 : microwave
% 13 : monitor
% 14 : pan
% 15 : pitcher
% 16 : soap_liquid
% 17 : tap
% 18 : tea_bag
% 19 : tooth_paste
% 20 : tv
% 21 : tv_remote
% 22 : mug_cup
% 23 : oven_stove
% 24 : person
% 25 : trash_can
% 26 : cloth
% 27 : knife_spoon_fork
% 28 : food_snack
% 29 : pills
% 30 : basket
% 31 : towel
% 32 : tooth_brush
% 33 : electric_keys
% 34 : container
% 35 : shoes
% 36 : cell_phone
% 37 : thermostat
% 38 : vacuum
% 39 : washer_dryer
% 40 : large_container
% 41 : keyboard
% 42 : blanket
% 43 : comb
% 44 : perfume
% 45 : milk_juice
% 46 : mop
% 47 : active_fridge
% 48 : active_bottle
% 49 : active_dish
% 50 : active_knife_spoon_fork
% 51 : active_food_snack
% 52 : active_microwave
% 53 : active_oven_stove
% 54 : active_tap
% 55 : active_pills
% 56 : active_tooth_brush
% 57 : active_tooth_paste
% 58 : active_tv_remote
% 59 : active_container
% 60 : active_trash_can
% 61 : active_mug_cup
% 62 : active_tea_bag
% 63 : active_soap_liquid
% 64 : active_laptop
% 65 : active_door
% 66 : active_towel
% 67 : active_thermostat
% 68 : active_pan
% 69 : active_cell_phone
% 70 : active_person
% 71 : active_dent_floss
% 72 : active_vacuum
% 73 : active_kettle
% 74 : active_pitcher
% 75 : active_detergent
% 76 : active_washer_dryer
% 77 : active_cell
% 78 : active_book
% 79 : active_shoes
% 80 : active_cloth
% 81 : active_comb
% 82 : active_electric_keys
% 83 : active_tv
% 84 : active_milk_juice
% 85 : active_basket
% 86 : active_large_container
% 87 : active_mop
% 88 : active_bed
% 89 : active_blanket