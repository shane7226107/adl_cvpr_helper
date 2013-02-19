function batch_ADL_annotation_to_haar(video_index_array , obj_index , show , debug)
    
    fprintf('running Batch ADL_annotation_to_haar_info\n'); 
    
    % Accumulating counter
    total_count = 0;
    
    for i=1:size(video_index_array,2)
        
        fprintf('\n\n\ngrabbing video: P_%02d.MP4    %d/%d in video array \n', video_index_array(1,i), i,size(video_index_array,2));
        
        if i == 1
            total_count = ADL_annotation_to_haar(video_index_array(1,i), obj_index, show ,debug);
        else
            total_count = ADL_annotation_to_haar(video_index_array(1,i), obj_index, show ,debug,total_count);
        end        
        
    end
end