function batch_annotation_new(video_list)
    
    info_dat_num = 12000;
    bg_txt_num = 12000;

    %Recreate the obj folders & open the fIDs
    obj_list = recreate_obj_folder();
    
    obj_counter_positive = zeros(size(obj_list));
    obj_counter_background = zeros(size(obj_list));
    
    for video=video_list
        
        %Load video
        video_obj = video_load(video);
        
        %Load annotation
        %index_to_str = num2str(video, '%02d');        
        obj_anno = obj_annotation_read(video);
        %Usage:
        %obj_anno{col}(row)
        %obj_anno{8}(1)
        
        %Record the bg created by this video
        obj_counter_background_in_this_video = zeros(size(obj_list));
        
        %Record the frame where this obj have shown
        %obj_record_positive(line,obj)
        obj_record_positive = zeros(size(obj_anno{1},1),size(obj_list,1));
        
        %Run through each line
        %Make positive annotation
        for line=1:size(obj_anno{1},1)
                    
            x = obj_anno{1}(line)*2;
            y = obj_anno{2}(line)*2;
            width = obj_anno{3}(line)*2 - x;
            height = obj_anno{4}(line)*2 - y;
            frame_index = obj_anno{5}(line);
            if frame_index==0
                frame_index = 1;
            end
            obj_index = obj_anno{7}(line);
            obj_name = char(obj_anno{8}(line));
            
            fprintf('video:%d positive line:%d/%d\n',video,line,size(obj_anno{1},1));
            fprintf('%d %d %d %d %d %d %s\n',x,y,width,height,frame_index,obj_index,obj_name);
            
            %skipping if the training data is enough
            if obj_counter_positive(obj_index) > info_dat_num
                fprintf('skkiping because the number is enough\n');
                continue;
            end
            
            %Positive
            %grab the frame
            frame = read(video_obj, frame_index);
            image(frame);
            rectangle('Position',[x y width height], 'LineWidth',2, 'EdgeColor','b');
            
            %Output
            info_dat_output([x y width height],frame,obj_index,obj_name,obj_counter_positive(obj_index));
            obj_counter_positive(obj_index) = obj_counter_positive(obj_index) + 1;
            obj_record_positive(line,obj_index) = frame_index;
        end
        
        %Run through each line again
        %Make background annotation
        for line=1:size(obj_anno{1},1)
            frame_index = obj_anno{5}(line);
            obj_index = obj_anno{7}(line);
            
            fprintf('video:%d background line:%d/%d\n',video,line,size(obj_anno{1},1));
            
            %skipping if the training data is enough
            if obj_counter_background(obj_index) > bg_txt_num
                fprintf('skkiping because the number is enough\n');
                continue;
            end
            
            %skipping when the bg create by this obj in this video is enough
            if obj_counter_background_in_this_video(obj_index) > 30
                continue;
            end
            
            %put this obj into other objs as bg data
            for other_obj=1:size(obj_list,1)
                
                %skipping the same obj
                if other_obj == obj_index
                    continue;
                end
                
                %skipping the other objs shown simultaneosly in the same frame
                if find(obj_record_positive(:,other_obj) == frame_index, 1)
                    continue;
                end
                
                %grab the frame
                frame = read(video_obj, frame_index);
                
                %make bg output
                bg_output(frame,other_obj,char(obj_list(other_obj)),obj_counter_background(other_obj));
                obj_counter_background(other_obj) = obj_counter_background(other_obj) +1;
            end
            
            obj_counter_background_in_this_video(other_obj) = obj_counter_background_in_this_video(other_obj) +1;
            
        end
    end
    
    fclose all;
    close all;
end

function obj_annotation = obj_annotation_read(index)    
    
    index_to_str = num2str(index, '%02d');
    
    filename = ['translated_with_obj_name/object_annot_P_' index_to_str '_translated_with_obj_name.txt'];
    fprintf('reading: %s\n', filename);
    
    fid = fopen(filename);
    
    obj_annotation = textscan(fid, '%d %d %d %d %d %d %d %s');
    
    fclose all;
    fprintf('finished reading annotation file\n');
end

function return_obj_list = recreate_obj_folder()
    fprintf('recreate the obj folders by obj_list.txt\n');
    
    system(['rm -r ' 'output']);
    system(['mkdir ' 'output']);
    
    filename = 'translated_with_obj_name/obj_list.txt';
    fid = fopen(filename);
    
    obj_list = textscan(fid, '%d : %s');
    for i=1:size(obj_list{1})
        index_to_str = num2str(i, '%02d');
        S = char(obj_list{2}(i));
        system(['mkdir ' 'output/' index_to_str '_' S]);
        system(['mkdir ' 'output/' index_to_str '_' S '/img']);
    end
    
    return_obj_list = obj_list{2};
end

function video_obj = video_load(index)
    fprintf('loading video...\n');
    index_to_str = num2str(index, '%02d');
    
    %Machine depandent file format
    if strcmp('GLNXA64',computer)
        %Run in Ubuntu
        filename = ['../../ADL_videos/raw/AVI/P_' index_to_str '.avi'];
    else
        %Run in Mac
        filename = ['../../ADL_videos/P_' index_to_str '.MP4'];
    end
    
    
    fprintf('%s\n',filename);
    xyloObj = VideoReader(filename);

    video_obj = xyloObj;
end

function info_dat_output(bbox,frame,obj_index,obj_name,count)    
    index_to_str = num2str(obj_index, '%02d');
    
    fid = fopen(['output/' index_to_str '_' obj_name '/info.dat'],'a');
    
    obj_folder = ['output/' index_to_str '_' obj_name];
    filename = sprintf('%s/img/%s_%05d.jpg',obj_folder,obj_name,count);
    imwrite(frame, filename);
    filename = sprintf('img/%s_%05d.jpg',obj_name,count);
    fprintf(fid, '%s 1 %d %d %d %d\n',filename,bbox(1,1),bbox(1,2),bbox(1,3),bbox(1,4));
    
    fclose all;
end

function bg_output(frame,obj_index,obj_name,count)
    
    index_to_str = num2str(obj_index, '%02d');
    
    fid = fopen(['output/' index_to_str '_' obj_name '/bg.txt'],'a');
   
    obj_folder = ['output/' index_to_str '_' obj_name];
    filename = sprintf('%s/img/background_%05d.jpg',obj_folder,count);
    imwrite(frame, filename);
    filename = sprintf('img/background_%05d.jpg',count);
    fprintf(fid, '%s\n',filename);
    
    fclose all;
end