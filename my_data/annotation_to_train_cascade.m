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
    
    num_of_obj = 21;
    num_of_videos = size(videos);
    obj_pos = zeros(num_of_obj,num_of_videos,20000);
    
    %
    %positive
    %
    for obj=1:num_of_obj
        
        fprintf('obj %d  %s\n',obj,obj_list{obj});
        
        filename = sprintf('cascade/%02d_%s.info',obj,obj_list{obj});
        fid_pos = fopen(filename,'w');
        
        for video=videos
            fprintf('seeking positive instances in video:%d\n',video);
            obj_annotation = obj_annotation_read(video);
            for line=1:size(obj_annotation{1},1)
                
                x = obj_annotation{1}(line);
                y = obj_annotation{2}(line);
                width = obj_annotation{3}(line) - x;
                height = obj_annotation{4}(line) - y;
                frame_index = obj_annotation{5}(line);
                obj_index = obj_annotation{7}(line);            
                
                
                if obj_index == obj                    
                    fprintf(fid_pos,'../img_P%02d_frame_%06d.jpg 1 %d %d %d %d\n',video,frame_index,x,y,width,height);
                    obj_pos(obj,video,frame_index) = 1;             
                end
            end
        end
        
        fclose(fid_pos);
        
        
    end   
    
    %
    %Background
    %
    for obj=1:num_of_obj
        
        filename = sprintf('cascade/%02d_%s.bg',obj,obj_list{obj});
        fid_bg = fopen(filename,'w');
        
        last_frame = -1;
        for video = videos
            fprintf('seeking positive instances in video:%d\n',video);
            obj_annotation = obj_annotation_read(video);
            
            for line=1:size(obj_annotation{1},1)
                
                frame_index = obj_annotation{5}(line);
                obj_index = obj_annotation{7}(line);
                
                if obj_index ~= obj && obj_pos(obj,video,frame_index) == 0 && frame_index ~= last_frame      
                    fprintf(fid_bg,'../img_P%02d_frame_%06d.jpg\n',video,frame_index);
                    last_frame = frame_index;
                end  

            end
        end
    end
    
    
    fclose(fid_bg);

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
    fclose(fid);
    fprintf('finished reading annotation file\n');
end