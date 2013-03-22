function batch_annotation_new(video_list)
    
    %Recreate the obj folders
    obj_list = recreate_obj_folder();
    
    obj_counter_positive = zeros(size(obj_list));
    obj_counter_background = zeros(size(obj_list));
    
    for video=video_list
        
        %Load video
        video_obj = video_load(video);
        
        %Load annotation
        index_to_str = num2str(video, '%02d');        
        obj_anno = obj_annotation_read(video);
        %Usage:
        %obj_anno{col}(row)
        %obj_anno{8}(1)
        
        %Run through each line
        for line=1:size(obj_anno{1},1)
            x = obj_anno{1}(line)*2;
            y = obj_anno{2}(line)*2;
            width = obj_anno{3}(line)*2 - x;
            height = obj_anno{4}(line)*2 - y;
            frame = obj_anno{5}(line);
            if frame==0
                frame = 1;
            end
            obj_index = obj_anno{7}(line);
            obj_name = char(obj_anno{8}(line));
            
            fprintf('%d %d %d %d %d %d %s\n',x,y,width,height,frame,obj_index,obj_name);
            
            %Positive
            %grab the frame
            frame = read(video_obj, frame);
            image(frame);
            rectangle('Position',[x y width height], 'LineWidth',2, 'EdgeColor','b');
            
            
        end
        
    end
    
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
    fprintf('recreate the obj folders by obj_list.txt');
    
    system(['rm -r ' 'output']);
    system(['mkdir ' 'output']);
    
    filename = 'translated_with_obj_name/obj_list.txt';
    fid = fopen(filename);
    
    obj_list = textscan(fid, '%d : %s');
    
    save('obj_list.mat','obj_list');
    
    %obj_list{2}(3)
    
    for i=1:size(obj_list{1})
        index_to_str = num2str(i, '%02d');
        S = char(obj_list{2}(i));
        system(['mkdir ' 'output/' index_to_str '_' S]);
    end
    
    return_obj_list = obj_list{2};
end

function video_obj = video_load(index)
    fprintf('loading video...\n');
    index_to_str = num2str(index, '%02d');
    
    %Machine depandent file format
    if strcmp('GLNXA64',computer)
        %Run in Ubuntu
        filename = ['../ADL_videos/raw/AVI/P_' index_to_str '.avi'];
    else
        %Run in Mac
        filename = ['../../ADL_videos/P_' index_to_str '.MP4'];
    end
    
    
    fprintf('%s\n',filename);
    xyloObj = VideoReader(filename);

    video_obj = xyloObj;
end

function info_dat_output(fid,bbox,frame,active_or_not,count,obj_name)
    
    if active_or_not
        state = 'active';
    else
        state = 'passive';
    end
    
    filename = sprintf('%simg/%s_%s_%05d.jpg',OBJ_FOLDER,state,label{obj_index},count);
    imwrite(frame, filename);
    filename = sprintf('img/%s_%s_%05d.jpg',state,label{obj_index},count);
    fprintf(fid, '%s 1 %d %d %d %d\n',filename,bbox(1,1),bbox(1,2),bbox(1,3),bbox(1,4));    
end