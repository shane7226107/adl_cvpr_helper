function action_label_for_crf_stageful_more_segment()
    dir_name = '../ADL_annotations/action_annotation/stageful_only';
    listing = dir(dir_name);

    use_record = 1;

    if(~use_record)
        %(action_annotation , action info , video_index)
        action_table = ones(100,6,32)*-1;
        action_counter = zeros(1,32);
        video_counter = 0;

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
                stage = lines(j,6);

                fprintf('%d:%d %d:%d %d %d\n',m_start,sec_start,m_end,sec_end,action_index);

                action_counter(1,action_index) = action_counter(1,action_index) + 1;
                action_table(action_counter(1,action_index),1,action_index)= m_start;
                action_table(action_counter(1,action_index),2,action_index)= sec_start;
                action_table(action_counter(1,action_index),3,action_index)= m_end;
                action_table(action_counter(1,action_index),4,action_index)= sec_end;
                action_table(action_counter(1,action_index),5,action_index)= video_counter;
                action_table(action_counter(1,action_index),6,action_index)= stage;
            end
        end

        save('action_table_complex.mat','action_table');
        save('action_counter_complex.mat','action_counter');

        
        %Load obj annotation for each video
        dir_name = '../ADL_annotations/object_annotation/translated_2';
        listing = dir(dir_name);

        %(obj_annotation , obj duration and video shown, obj_index)
        obj_table = ones(600,3,89)*-1;
        obj_counter = zeros(1,89);

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

                obj_counter(1,obj_index) = obj_counter(1,obj_index) + 1;
                obj_table(obj_counter(1,obj_index),1,obj_index) = frame_index;
                obj_table(obj_counter(1,obj_index),2,obj_index) = 0;
                obj_table(obj_counter(1,obj_index),3,obj_index) = video_counter;            
            end

        end    
        save('obj_table_complex.mat','obj_table');    
        save('obj_counter_complex.mat','obj_counter');    
    else

        load('obj_table_complex.mat');
        load('action_table_complex.mat');
        load('obj_counter_complex.mat');
        load('action_counter_complex.mat');

    end 

    %By using the action table and obj table ,build the action labels with
    %observations
    %(action_annotation , action time , video_index)    
    %(obj_annotation , obj duration , video_index)
    stageful_action  = [9, 12, 13, 16];
    %the 90th feature is the video index where the action shown
    %the 91th .... is the stage index, 0 means single state
    action_observation_table = ones(1000,91,32)*-1;
    action_observation_counter = zeros(1,32);
    start_end_buffer = zeros(3,2);
    
    for action = stageful_action
                
        fprintf('\n===============================\n proceesing : action %d\n',action);
         
        for i=1:action_counter(1,action)           
            
            m_start = action_table(i,1,action);
            s_start = action_table(i,2,action);
            m_end = action_table(i,3,action);
            s_end = action_table(i,4,action);
            video_index = action_table(i,5,action);
            stage = action_table(i,6,action);
            
            %Approximation here..
            fps = 30;
            start_frame_a = round(m_start*60*fps + s_start*fps);
            end_frame_a = round(m_end*60*fps + s_end*fps);
            
            %Produce the biggest segment as training data
            start_frame = start_frame_a;
            end_frame = end_frame_a;
            
            %Keep start_end frame info
            if stage == 1
                start_end_buffer(1,1) = start_frame;
                start_end_buffer(1,2) = end_frame;
            elseif stage == 2
                start_end_buffer(2,1) = start_frame;
                start_end_buffer(2,2) = end_frame;
            else
                start_end_buffer(3,1) = start_frame;
                start_end_buffer(3,2) = end_frame;
            end
            
            fprintf('%d:%d -> %d:%d in video %d\n',m_start,s_start,m_end,s_end,video_index);
            fprintf('frame:%d -> %d\n',start_frame,end_frame);
            
            action_observation_counter(1,action) = action_observation_counter(1,action) + 1;      
            
            for obj=1:89
                for j=1:obj_counter(1,obj)
                     
                    obj_in_video = obj_table(j,3,obj);
                    
                    if obj_in_video == video_index
                                                
                        obj_frame_start = obj_table(j,1,obj);
                                                
                        if obj_frame_start >= start_frame && obj_frame_start <= end_frame
                            fprintf('obj %d shown in video %d for action %d\n',obj,video_index,action);                            
                            action_observation_table(action_observation_counter(1,action),obj,action) = 1;
                            action_observation_table(action_observation_counter(1,action),90,action) = obj_in_video;
                            action_observation_table(action_observation_counter(1,action),91,action) = stage;
                            break;
                        else
                            action_observation_table(action_observation_counter(1,action),obj,action) = 0;
                        end                        
                                        
                    else
                        action_observation_table(action_observation_counter(1,action),obj,action) = 0;
                    end
                end
            end
            
            
            %TODO ?????action table?????stage, ?????moresegment, ??continue
            if action_table(i+1,6,action) == 0 || action_table(i+1,6,action) == 1
                %more segment
                
            end
            
            %Produce "lot more" segments as training data
%             for stat_frame=start_frame_a:150:end_frame_a
%                 end_frame = stat_frame + 150;
%                 fprintf('%d:%d -> %d:%d in video %d\n',m_start,s_start,m_end,s_end,video_index);
%                 fprintf('frame:%d -> %d\n',start_frame,end_frame);
% 
%                 action_observation_counter(1,action) = action_observation_counter(1,action) + 1;      
% 
%                 for obj=1:89
%                     for j=1:obj_counter(1,obj)
% 
%                         obj_in_video = obj_table(j,3,obj);
% 
%                         if obj_in_video == video_index
% 
%                             obj_frame_start = obj_table(j,1,obj);
% 
%                             if obj_frame_start >= start_frame && obj_frame_start <= end_frame
%                                 fprintf('obj %d shown in video %d for action %d\n',obj,video_index,action);                            
%                                 action_observation_table(action_observation_counter(1,action),obj,action) = 1;
%                                 action_observation_table(action_observation_counter(1,action),90,action) = obj_in_video;
%                                 action_observation_table(action_observation_counter(1,action),91,action) = stage;
%                                 break;
%                             else
%                                 action_observation_table(action_observation_counter(1,action),obj,action) = 0;
%                             end                        
% 
%                         else
%                             action_observation_table(action_observation_counter(1,action),obj,action) = 0;
%                         end
%                     end
%                 end
%             end
            
        end
    end
    action_observation_counter_complex = action_observation_counter;
    action_observation_table_complex = action_observation_table;
    save('action_observation_counter_complex.mat','action_observation_counter_complex');
    save('action_observation_table_complex.mat','action_observation_table_complex');
    
end

function obj_annotation = obj_annotation_read(name)    
    
    fid = fopen(name);
    
    [A ,count] = fscanf(fid, '%d %d %d %d %d %d %d',[7 , inf]);
    obj_annotation = A';
    
    fclose all;
end

function action_annotation = file_read(name)
    
    fid = fopen(name);
    
    %00:08 00:33 12 1
    %00:59 01:30 12 2
    [A ,count] = fscanf(fid, '%d:%d %d:%d %d %d',[6 , inf]);
    
    action_annotation = A';
    
    %fclose all;
end