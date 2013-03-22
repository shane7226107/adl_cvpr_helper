function batch_annotation_new(video_list)
    
    %Recreate the obj folders
    recreate_obj_folder();
    
    for video=video_list
        
        index_to_str = num2str(video, '%02d');
        
        obj_anno = obj_annotation_read(video);
        %obj_anno{col}{line}
        
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

function recreate_obj_folder()
    fprintf('recreate the obj folders by obj_list.txt');
    
    system(['rm -r ' 'output']);
    system(['mkdir ' 'output']);
    
    filename = 'translated_with_obj_name/obj_list.txt';
    fid = fopen(filename);
    
    obj_list = textscan(fid, '%d : %s');
    
    save('obj_list.mat','obj_list');
    
    %obj_list{2}(3)
    
    for i=1:size(obj_list{2})
        index_to_str = num2str(i, '%02d');
        S = char(obj_list{2}(i))
        system(['mkdir ' 'output/' index_to_str '_' S]);
    end
end