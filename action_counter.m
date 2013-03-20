function action_counter()
    dir_name = 'ADL_annotations/action_annotation/no_additional_comment';
    listing = dir(dir_name);
    
    action_list = zeros(1,32);
    action_list = [1:32 ; action_list];
    counter = 0;
    for i=1:size(listing,1)
        
        if(strcmp(listing(i).name,'.') || strcmp(listing(i).name,'..') || strcmp(listing(i).name,'.DS_Store'))
            continue;
        end
        
        fprintf('processing : %s\n',listing(i).name);
        
        line = file_read([dir_name '/' listing(i).name]);        
        
        %save('test.mat','line');
        
        for j=1:size(line,1)
            fprintf('%d:%d %d:%d %d\n',line(j,1),line(j,2),line(j,3),line(j,4),line(j,5));
            action_list_acc(counter+1) = line(j,5);
            action_list(2,line(j,5)) = action_list(2,line(j,5)) + 1;
            counter = counter+1;
        end
        
        action_list
        [Y,I]=sort(action_list(2,:),'descend');
        B=action_list(:,I)
        %hist(action_list_acc,32);
        

    end
  
end

function obj_annotation = file_read(name)
    
    fid = fopen(name);
    
    %00:08 00:33 14
    [A ,count] = fscanf(fid, '%d:%d %d:%d %d',[5 , inf]);
    
    obj_annotation = A';
    
    %fclose all;
end