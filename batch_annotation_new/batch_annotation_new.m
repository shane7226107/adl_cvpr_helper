function batch_annotation_new(video_list)
    
    %Recreate the obj folders
    num_objs = recreate_obj_folder()
    
    obj_counter_positive = zeros(1,num_objs);
    obj_counter_background = zeros(1,num_objs);
    
    for video=video_list
        
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
            obj_index = obj_anno{7}(line);
            obj_name = char(obj_anno{8}(line));
            
            fprintf('%d %d %d %d %d %d %s\n',x,y,width,height,frame,obj_index,obj_name);
        end
        
        
        save(['P_' index_to_str '_obj_anno.mat'],'obj_anno');
    end
    
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

function num_of_objs = recreate_obj_folder()
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
    
    num_of_objs = size(obj_list{1},1);
end