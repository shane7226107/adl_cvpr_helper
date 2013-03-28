function action_observation_to_crf(action_list)
    load('action_observation_counter.mat');
    load('action_observation_table.mat');
    
    f_out_id = fopen('crf_train.txt','w');
    
    %training actions in CVPR2012
    %[1 2 3 4 5 6 9 10 11 12 13 14 15 17 20 22 23 24]
    
    sample_set = [1 2 3 4 5 6];
    %sample_set = 1:20;
    
    for action=action_list
        
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
                
                fprintf(f_out_id,'%d\n\n',action);
                
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