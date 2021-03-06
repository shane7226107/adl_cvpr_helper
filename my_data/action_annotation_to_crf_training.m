function action_annotation_to_crf_training()

    fprintf('action_annotation_to_crf_training\n');
    
    video_length = [10831 12481 14551 12331 13021];
    
    FPN = 90;
    
    for video=1:5
        
        filename = sprintf('action_crf_training/P_%02d.txt',video);
        fid_out = fopen(filename,'w');
        
        %Object annotaion reading
        obj_annotation = obj_annotation_read(video);
        
        obj_frame_matrix = zeros(video_length(video),21);
        
        for line=1:size(obj_annotation{1},1)
            
            x = obj_annotation{1}(line);
            y = obj_annotation{2}(line);
            width = obj_annotation{3}(line) - x;
            height = obj_annotation{4}(line) - y;
            frame_index = obj_annotation{5}(line);
            obj_id = obj_annotation{7}(line);   
            
            obj_frame_matrix(frame_index,obj_id) = 1;
        end
        
        %Action annotaion reading
        action_annotation = action_annotation_read(video);
        
        for line=1:size(action_annotation{1},1)        
            
            start_frame = action_annotation{1}(line);
            end_frame = action_annotation{2}(line);
            action_id = action_annotation{3}(line);
            action_name = action_annotation{4}{line};
            
            if ~isempty(strfind(action_name, 'stage'))
                fprintf('multi stage action : %s\n',action_name);
                
                if ~isempty(strfind(action_name, 'make_coffee_stage_1'))
                    make_coffee(1) = start_frame;
                    make_coffee(2) = end_frame;
                elseif ~isempty(strfind(action_name, 'make_coffee_stage_2'))
                    make_coffee(3) = start_frame;
                    make_coffee(4) = end_frame;
                elseif ~isempty(strfind(action_name, 'copy_documents_stage_1'))
                    copy_documents(1) = start_frame;
                    copy_documents(2) = end_frame;
                elseif ~isempty(strfind(action_name, 'copy_documents_stage_2'))
                    copy_documents(3) = start_frame;
                    copy_documents(4) = end_frame;
                else                    
                    %ignoring copy document stage 3
                end
                
                %continue;
            else
                fprintf('%d %d %d %s \n', start_frame,end_frame,action_id,action_name);
            end
            
            fprintf('%d %d %d %s \n', start_frame,end_frame,action_id,action_name);
            
            features = zeros(1,21);
            
            for frame=start_frame:FPN:end_frame
                
                if frame > video_length(video)
                    continue;
                end            
                
                features = features | obj_frame_matrix(frame,:);
                
                %output
                fprintf(fid_out,'%d ',features(1,:));
                fprintf(fid_out,'%s \n\n',action_name);
            end            
        end
        
        %multi-stage outputs
        %coffee
        features_stage_1 = zeros(1,21);
        features_stage_2 = zeros(1,21);
        for frame=make_coffee(1):1:make_coffee(2)
                
            if frame > video_length(video)
                continue;
            end            

            features_stage_1 = features_stage_1 | obj_frame_matrix(frame,:);            
        end
        for frame=make_coffee(3):1:make_coffee(4)
                
            if frame > video_length(video)
                continue;
            end            

            features_stage_2 = features_stage_2 | obj_frame_matrix(frame,:);            
        end
        %output
        fprintf(fid_out,'%d ',features_stage_1(1,:));
        fprintf(fid_out,'%s \n','make_coffee_stage_1');
        fprintf(fid_out,'%d ',features_stage_2(1,:));
        fprintf(fid_out,'%s \n\n','make_coffee_stage_2');
        
        %multi-stage outputs
        %copy
        features_stage_1 = zeros(1,21);
        features_stage_2 = zeros(1,21);
        for frame=copy_documents(1):1:copy_documents(2)
                
            if frame > video_length(video)
                continue;
            end            

            features_stage_1 = features_stage_1 | obj_frame_matrix(frame,:);            
        end
        for frame=copy_documents(3):1:copy_documents(4)
                
            if frame > video_length(video)
                continue;
            end            

            features_stage_2 = features_stage_2 | obj_frame_matrix(frame,:);            
        end
        %output
        fprintf(fid_out,'%d ',features_stage_1(1,:));
        fprintf(fid_out,'%s \n','copy_documents_stage_1');
        fprintf(fid_out,'%d ',features_stage_2(1,:));
        fprintf(fid_out,'%s \n\n','copy_documents_stage_2');
        
        
    end
    
    
    %save('obj_frame_matrix.mat','obj_frame_matrix');
end

function obj_annotation = obj_annotation_read(index)    
    
    filename = sprintf('annotations/objects/P%02d.mp4_label.txt',index);
    
    fprintf('reading: %s\n', filename);
    
    fid = fopen(filename);
    %236 147 387 290 000001 0 1
    obj_annotation = textscan(fid, '%d %d %d %d %d %d %d');
    %Usage:
    %obj_anno{col}(row)
    %obj_anno{7}(1)
    fclose(fid);
    fprintf('finished reading objects annotation file\n');
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
