function annotation_to_train_cascade()


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
    11: copier %keyboard = 'c'
%}

for obj=1:11
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