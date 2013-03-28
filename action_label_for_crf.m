function action_label_for_crf()
    dir_name = '../ADL_annotations/action_annotation/no_additional_comment';
    listing = dir(dir_name);
    
    %(action_annotation , action time , video_index)
    action_table = ones(100,5,32)*-1;
    action_counter = zeros(1,32);
    video_counter = 0;
    
    %(obj_annotation , obj duration , video_index)
    obj_table = ones(500,2,89)*-1;
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
    
    
    
    for i=1:size(listing,1)
        if(strcmp(listing(i).name,'.') || strcmp(listing(i).name,'..') || strcmp(listing(i).name,'.DS_Store'))
            continue;
        end
        
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
            else
                obj_counter(1,obj_index) = obj_counter(1,obj_index) + 1;
                if last_obj == -1
                    %The beginning of file
                    obj_table(obj_counter(1,obj_index),1,obj_index) = frame_index;
                    %For those with only 1 line annotation
                    obj_table(obj_counter(1,obj_index),2,obj_index) = frame_index + 30;
                    
                    last_obj = obj_index;
                else
                    obj_table(obj_counter(1,last_obj),2,last_obj) = last_frame;
                    
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
    % stageful action [9, 12, 13, 16]
    action_observation_table = ones(100,89,32)*-1;
    
    
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