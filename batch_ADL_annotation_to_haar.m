% In CVPR 2012, they choose first 6 video as traning set
% and only uses part of the annotations(better quality?)
% which are:
% obj_index : 
%             passive:
%             {
%               'bed': '1','book': '2','bottle':'3','cell':'4','dent_floss':'5',
%               'detergent':'6','dish':'7','door':'8','fridge':'9','kettle':'10',
%               'laptop':'11','microwave':'12','monitor':'13','pan':'14','pitcher':'15',
%               'soap_liquid':'16','tap':'17','tea_bag':'18','tooth_paste':'19','tv':'20',
%               'tv_remote':'21'
%             }
%             active:
%             {
%               'fridge':'9','microwave':'12','soap_liquid':'16','mug/cup':'22','oven/stove':'23'
%             }


function batch_ADL_annotation_to_haar(video_index_array ,obj_index, active_or_not ,show ,debug)
    
    fprintf('running Batch ADL_annotation_to_haar_info\n'); 
    
    %Argin translation
    if strcmp(obj_index,'all')
        all_objects = 1;
    else
        all_objects = 0;
    end
    
    if strcmp(active_or_not,'active')
        active_or_not = 1;
    else
        active_or_not = 0;
    end
    
    if strcmp(show,'show')
        show = 1;
    else
        show = 0;
    end
    
    if strcmp(debug,'debug')
        debug = 1;
    else
        debug = 0;
    end
    
    %Global variables
    global DEBUG_COUNT LABEL
    %Maximum number before breaking
    DEBUG_COUNT = 2;
    %obj labels
    LABEL = {
            'bed' 'book' 'bottle' 'cell' 'dent_floss'
            'detergent' 'dish' 'door' 'fridge' 'kettle'
            'laptop' 'microwave' 'monitor' 'pan' 'pitcher'
            'soap_liquid' 'tap' 'tea_bag' 'tooth_paste' 'tv'
            'tv_remote' 'mug_cup' 'oven_stove' 'person' 'trash_can'
            'cloth' 'knife_spoon_fork' 'food_snack' 'pills' 'basket'
            'towel' 'tooth_brush' 'electric_keys' 'container' 'shoes'
            'cell_phone' 'thermostat' 'vacuum' 'washer_dryer' 'large_container'
            'keyboard' 'blanket' 'comb' 'perfume' 'milk_juice'
            'mop' 'none' 'none' 'none' 'none'
        };
    
    %The all obj array for 'all' mode
    %Taking obj from 1:23 just like CVPR12
    all_obj_index_array = 1:23;
    %The active objs array
    active_objs = [9 12 16 22 23];    
    
    % Recreate the output folders
    system('rm -r output');
    system('mkdir output'); 
    
    % Accumulating counter [foreground background]
    total_count = [0 0];     
    
    %Single object mode
    if (all_objects == 0)
        fprintf('single object mode: %d\n',obj_index);
        
        %Decide the repeat number to get enough sample first
        repeat = total_annotation_counter(video_index_array,obj_index, active_or_not);
        for i=1:size(video_index_array,2)

            fprintf('\n\n\ngrabbing video: P_%02d    %d/%d in video array \n', video_index_array(1,i), i,size(video_index_array,2));
            
            if i == 1
                total_count = ADL_annotation_to_haar(video_index_array(1,i), obj_index ,active_or_not ,show ,debug, [0 0],repeat);
            else
                total_count = ADL_annotation_to_haar(video_index_array(1,i), obj_index ,active_or_not ,show ,debug, total_count ,repeat);
            end        

        end
        
    %All objects mode
    else
        fprintf('all objects mode\n');
        
        for obj_index=all_obj_index_array            
            %passive
            %Decide the repeat number to get enough sample first
            repeat = total_annotation_counter(video_index_array,obj_index, 0);
            
            for video=1:size(video_index_array,2)

                fprintf('\n\n\ngrabbing video: P_%02d    %d/%d in video array for passive object: %d\n', video_index_array(1,video), video,size(video_index_array,2),obj_index);
                
                if video == 1
                    total_count = ADL_annotation_to_haar(video_index_array(1,video), obj_index ,false ,show ,debug ,[0 0],repeat);
                else
                    total_count = ADL_annotation_to_haar(video_index_array(1,video), obj_index ,false ,show ,debug, total_count, repeat);
                end        

            end
            %active
            %Only for those with active annotation
            tmp = ones(1,5) * obj_index;
   
            if ~isequal(tmp == active_objs, [0 0 0 0 0])
                %Decide the repeat number to get enough sample first
                repeat = total_annotation_counter(video_index_array,obj_index, 1);
                
                for video=1:size(video_index_array,2)

                    fprintf('\n\n\ngrabbing video: P_%02d.MP4    %d/%d in video array for active object: %d\n', video_index_array(1,video), video,size(video_index_array,2),obj_index);
                                  
                    if video == 1
                        total_count = ADL_annotation_to_haar(video_index_array(1,video), obj_index ,true ,show ,debug,[0 0],repeat);
                    else
                        total_count = ADL_annotation_to_haar(video_index_array(1,video), obj_index ,true ,show ,debug, total_count ,repeat);
                    end        

                end
            end
        end
    end
    
    
    fprintf('Batch ADL_annotation_to_haar_info all Done!\n'); 
end

function repeat = total_annotation_counter(video_index_array,obj_index, active_or_not)
    
    global LABEL
    
    if active_or_not == 1
        state = 'active';
    else
        state = 'passive';
    end
    
    annotation_counter = 0;
    label = LABEL';
    
    for video = video_index_array
        obj_annotation = obj_annotation_read(video);
        
        for i=1:size(obj_annotation,1)
            if (obj_index == obj_annotation(i,7))
                if (active_or_not == obj_annotation(i,6))
                    annotation_counter = annotation_counter + 1;
                end
            end        
        end
    end
    
    fprintf('Number of annotations of required obj_%d_%s_%s is %d\n',obj_index,state,label{obj_index},annotation_counter);
    if annotation_counter > 0 
        repeat = ceil(7100/(annotation_counter)));        
        fprintf('Number of repeats needed:%d, To make %d samples\n',repeat,repeat* (annotation_counter)));    
    else
        repeat = 1;
        fprintf('Number of repeats is 1 because there is no such obj in this video set\n');    
    end
end

function obj_annotation = obj_annotation_read(index)    
    index_to_str = num2str(index, '%02d');
    filename = ['../ADL_annotations/object_annotation/object_annot_P_' index_to_str '_translated.txt'];
    fprintf('reading: %s\n', filename);
    
    fid = fopen(filename);
    
    [A ,count] = fscanf(fid, '%d %d %d %d %d %d %d',[7 , inf]);
    obj_annotation = A';
    
    fclose all;
    fprintf('finished reading annotation file\n');
end