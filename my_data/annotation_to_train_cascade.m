function annotation_to_train_cascade(videos)


%obj_list
%{            
    1 : laptop
    2 : cup
    3 : book
    4 : teabag
    5 : cell
    6 : window
    7 : papers
    8 : dispenser
    9 : tap
    10: human
    21: copier %keyboard = 'c'
%}
    
    global obj_list
    obj_list = {          
        'laptop'
        'cup'
        'book'
        'teabag'
        'cell'
        'window'
        'papers'
        'dispenser'
        'tap'
        'human'
        'active_laptop'
        'active_cup'
        'active_book'
        'active_teabag'
        'active_cell'
        'active_window'
        'active_papers'
        'active_dispenser'
        'active_tap'
        'active_human'
        'active_copier'
    };
    obj_list = obj_list';
    
    for obj=1:21
        fprintf('obj %d  %s\n',obj,obj_list{obj});
        for video=videos
            
        end
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