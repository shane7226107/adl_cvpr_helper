function action_label_for_crf()
    dir_name = '../ADL_annotations/action_annotation/no_additional_comment';
    listing = dir(dir_name);
    
    %(action_annotation , action time , video_index)
    action_table = ones(100,5,32)*-1;
    action_counter = zeros(1,32);
    video_counter = 0;
    
    %(obj_annotation , obj duration and video shown, obj_index)
    obj_table = ones(500,3,89)*-1;
    obj_counter = zeros(1,89);
    
    %Load action annotation for each video
    for i=1:size(listing,1)
        
        if(strcmp(listing(i).name,'.') || strcmp(listing(i).name,'..') || strcmp(listing(i).name,'.DS_Store'))
            continue;
        end
        
        video_counter = video_counter + 1 ; 
        
        fprintf('\n=============\n processing : %s\n',listing(i).name);
        
        lines = file_read([dir_name '/' listing(i).name]);        
        
        %Run through the lines in the file
        for j=1:size(lines,1)
            m_start = lines(j,1);
            sec_start = lines(j,2);
            m_end = lines(j,3);
            sec_end = lines(j,4);
            action_index = lines(j,5);
            
            fprintf('%d:%d %d:%d %d\n',m_start,sec_start,m_end,sec_end,action_index);
            
            action_counter(1,action_index) = action_counter(1,action_index) + 1;
            action_table(action_counter(1,action_index),1,action_index)= m_start;
            action_table(action_counter(1,action_index),2,action_index)= sec_start;
            action_table(action_counter(1,action_index),3,action_index)= m_end;
            action_table(action_counter(1,action_index),4,action_index)= sec_end;
            action_table(action_counter(1,action_index),5,action_index)= video_counter;
        end
    end
    
    save('action_table.mat','action_table');
    
    
    
    %Load obj annotation for each video
    dir_name = '../ADL_annotations/object_annotation/translated_2';
    listing = dir(dir_name);
    
    video_counter = 0;
    
    for i=1:size(listing,1)
        if(strcmp(listing(i).name,'.') || strcmp(listing(i).name,'..') || strcmp(listing(i).name,'.DS_Store'))
            continue;
        end
        
        video_counter = video_counter + 1;
        
        fprintf('\n=============\n processing : %s\n',listing(i).name);
        obj_annotation = obj_annotation_read([dir_name '/' listing(i).name]);        
        
        last_obj = -1;
        last_frame = -1;
        
        for j=1:size(obj_annotation,1)
            obj_index = obj_annotation(j,7);
            frame_index = obj_annotation(j,5);
            x1 = obj_annotation(j,1)*2; %Have to multiply by 2 here(WTF!)
            y1 = obj_annotation(j,2)*2;
            width = obj_annotation(j,3)*2 - x1;
            height = obj_annotation(j,4)*2 - y1;
            %fprintf('%d %d %d %d %d %d\n',x1,y1,width,height,frame_index,obj_index);
            
            if obj_index == last_obj
                last_frame = frame_index;
                obj_table(obj_counter(1,obj_index),3,obj_index) = video_counter;
            else
                obj_counter(1,obj_index) = obj_counter(1,obj_index) + 1;
                if last_obj == -1
                    %The beginning of file
                    obj_table(obj_counter(1,obj_index),1,obj_index) = frame_index;
                    %For those with only 1 line annotation
                    obj_table(obj_counter(1,obj_index),2,obj_index) = frame_index + 30;
                    obj_table(obj_counter(1,obj_index),3,obj_index) = video_counter;
                    
                    last_obj = obj_index;
                else
                    obj_table(obj_counter(1,last_obj),2,last_obj) = last_frame;
                    obj_table(obj_counter(1,last_obj),3,last_obj) = video_counter;
                    
                    obj_table(obj_counter(1,obj_index),1,obj_index) = frame_index;
                    %For those with only 1 line annotation
                    obj_table(obj_counter(1,obj_index),2,obj_index) = frame_index + 30;
                    
                    last_obj = obj_index;
                end
            end
        end
        
    end    
    
    save('obj_table.mat','obj_table');
    
    %By using the action table and obj table ,build the action labels with
    %observations
    %(action_annotation , action time , video_index)    
    %(obj_annotation , obj duration , video_index)
    stageful_action  = [9, 12, 13, 16];
    action_observation_table = ones(100,89,32)*-1;
    action_observation_counter = zeros(1,32);
    
    for action = 1:32
        if ~isempty(find(stageful_action==action, 1))
            fprintf('stageful action %d skipped\n',action);
            continue;
        end 
        
        fprintf('\n===============================\n proceesing : action %d\n',action);
        
        for i=1:action_counter(1,action)           
            
            m_start = action_table(i,1,action);
            s_start = action_table(i,2,action);
            m_end = action_table(i,3,action);
            s_end = action_table(i,4,action);
            video_index = action_table(i,5,action);
            %Approximation here..
            start_frame = round(m_start*60*29.97 + s_start*29.97);
            end_frame = round(m_end*60*29.97 + s_end*29.97);
            
            fprintf('%d:%d -> %d:%d in video %d\n',m_start,s_start,m_end,s_end,video_index);
            fprintf('frame:%d -> %d\n',start_frame,end_frame);
            
            action_observation_counter(1,action) = action_observation_counter(1,action) + 1;      
            
            for obj=1:89
                for j=1:obj_counter(1,obj)
                    if obj_table(j,3,obj) == video_index
                        %fprintf('obj %d shown in video %d for action %d\n',obj,video_index,action);
                        %fprintf('obj %d shown in video %d%d\n',obj,video_index);
                        if abs(start_frame-obj_table(j,1,obj)) < 30 && abs(end_frame-obj_table(j,2,obj))
                            fprintf('obj %d shown in video %d for action %d\n',obj,video_index,action);
                        end
                    end
                end
            end
            
        end
    end
    
    save('action_observation_table.mat','action_observation_table');
    
end

function obj_annotation = obj_annotation_read(name)    
    
    fid = fopen(name);
    
    [A ,count] = fscanf(fid, '%d %d %d %d %d %d %d',[7 , inf]);
    obj_annotation = A';
    
    fclose all;
end

function action_annotation = file_read(name)
    
    fid = fopen(name);
    
    %00:08 00:33 14
    [A ,count] = fscanf(fid, '%d:%d %d:%d %d',[5 , inf]);
    
    action_annotation = A';
    
    %fclose all;
end