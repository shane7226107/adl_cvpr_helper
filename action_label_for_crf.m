function action_label_for_crf()
    dir_name = '../ADL_annotations/action_annotation/no_additional_comment';
    listing = dir(dir_name);
    
    %(action_annotation , action time , video_index)
    action_table = ones(100,5,32)*-1;
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
        
        %builid the action table
        
    end
    
    
    
    
    
    %By using the action table and obj table ,build the action labels with
    %observations
  
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