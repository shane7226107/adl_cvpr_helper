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
    
    %The all obj array for 'all' mode
    all_obj_index_array = [1 9 12];
    %The active objs array
    active_objs = [9 12 16 22 23];    
    
    % Recreate the output folders
    system('rm -r output');
    system('mkdir output'); 
    
    % Accumulating counter [foreground background]
    total_count = [0 0];     
    
    %Single object mode
    if (all_objects == 0)
        fprintf('single object: %d\n',obj_index);
        for i=1:size(video_index_array,2)

            fprintf('\n\n\ngrabbing video: P_%02d.MP4    %d/%d in video array \n', video_index_array(1,i), i,size(video_index_array,2));

            if i == 1
                total_count = ADL_annotation_to_haar(video_index_array(1,i), obj_index ,active_or_not ,show ,debug);
            else
                total_count = ADL_annotation_to_haar(video_index_array(1,i), obj_index ,active_or_not ,show ,debug, total_count);
            end        

        end
        
    %All objects mode
    else
        fprintf('all objects\n');
        
        for obj=all_obj_index_array
            %passive
            for video=1:size(video_index_array,2)

                fprintf('\n\n\ngrabbing video: P_%02d.MP4    %d/%d in video array for passive object: %d\n', video_index_array(1,video), video,size(video_index_array,2),obj);

                if video == 1
                    total_count = ADL_annotation_to_haar(video_index_array(1,video), obj ,false ,show ,debug);
                else
                    total_count = ADL_annotation_to_haar(video_index_array(1,video), obj ,false ,show ,debug, total_count);
                end        

            end
            %active
            %Only for those with active annotation
            tmp = ones(1,5) * obj;
   
            if ~isequal(tmp == active_objs, [0 0 0 0 0])
                for video=1:size(video_index_array,2)

                    fprintf('\n\n\ngrabbing video: P_%02d.MP4    %d/%d in video array for active object: %d\n', video_index_array(1,video), video,size(video_index_array,2),obj);

                    if video == 1
                        total_count = ADL_annotation_to_haar(video_index_array(1,video), obj ,true ,show ,debug);
                    else
                        total_count = ADL_annotation_to_haar(video_index_array(1,video), obj ,true ,show ,debug, total_count);
                    end        

                end
            end
        end
    end
    
    
    fprintf('Batch ADL_annotation_to_haar_info all Done!\n'); 
end