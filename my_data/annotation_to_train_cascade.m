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
            fprintf('seeking object in video:%d\n',video);
            obj_annotation = obj_annotation_read(video);
            for line=1:size(obj_annotation{1},1)
                x = obj_annotation{1}(line);
                y = obj_annotation{2}(line);
                width = obj_annotation{3}(line) - x;
                height = obj_annotation{4}(line) - y;
                frame_index = obj_annotation{5}(line);
                obj_index = obj_annotation{7}(line);            
                
                fprintf('%d %d %d %d %06d %d\n',x,y,width,height,frame_index,obj_index);
            end
        end
    end

end

function obj_annotation = obj_annotation_read(index)    
    
    filename = sprintf('annotations/P%02d.mp4_label.txt',index);
    
    fprintf('reading: %s\n', filename);
    
    fid = fopen(filename);
    %236 147 387 290 000001 0 1
    obj_annotation = textscan(fid, '%d %d %d %d %d %d %d');
    %Usage:
    %obj_anno{col}(row)
    %obj_anno{7}(1)
    fclose all;
    fprintf('finished reading annotation file\n');
end