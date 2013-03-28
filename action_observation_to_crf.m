function action_observation_to_crf(action_list)
    load('action_observation_counter.mat');
    load('action_observation_table.mat');
    
    for action=action_list
        
        fprintf('action %d \n',action);
        feature_sum = zeros(1,89);
        
        for i=1:action_observation_counter(1,action)
            
            features = action_observation_table(i,:,action);
            feature_sum = feature_sum + features;
        end
        
        plot(feature_sum);
        k = waitforbuttonpress;
    end
    
    close all
end