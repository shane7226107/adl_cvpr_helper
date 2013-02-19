function ADL_annotation_to_haar(video_index, obj_index, show ,debug)
    fprintf('running ADL_annotation_to_haar_info\n');
    
    system('rm -r img');
    system('mkdir img');
    
    obj_annotation = obj_annotation_read(video_index);
    grab_info_and_img(video_index, obj_annotation, obj_index , show , debug);    
    
    fprintf('Done!\n');
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

function video_obj = video_load(index)
    fprintf('reading video...\n');
    index_to_str = num2str(index, '%02d');
    filename = ['../ADL_videos/P_' index_to_str '.MP4'];
    
    xyloObj = VideoReader(filename);

%     nFrames = xyloObj.NumberOfFrames;
%     vidHeight = xyloObj.Height;
%     vidWidth = xyloObj.Width;
    
    % Preallocate movie structure.
%     mov(1:nFrames) = ...
%         struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
%                'colormap', []);
           
    video_obj = xyloObj;
end

function grab_info_and_img(video_index, obj_annotation , obj_index , show ,debug)
    if nargin < 5
        debug = false;
    end

    fprintf('grabbing img and output info.dat...\n');
    
    video_obj = video_load(video_index);
    
    fid = fopen('info.dat','w');
    
    if show 
        figure;
    end
    
    count = 0;
    
    for i=1:size(obj_annotation,1)
        
        if(mod((i/video_obj.NumberOfFrames * 100),10) <= 0.002)
            fprintf('%.2f...\n', i/video_obj.NumberOfFrames * 100);
        end
        
        
        %When finding required obj_index
        if obj_index == obj_annotation(i,7)
            
            % Grab inter frames in each interval (out of 30 frames)
            % Setup frequency param here
            for j=0:6:30
                
                count = count + 1;
                %Debug mode
                if debug && count > 10
                    break;
                end

                %Avoid to crash at boundaries
                frame_to_grab = obj_annotation(i,5) + j;
                if frame_to_grab == 0
                  frame_to_grab = 1;
                elseif frame_to_grab == video_obj.NumberOfFrames;
                  frame_to_grab = video_obj.NumberOfFrames;
                end
                
                %The bbox
                x1 = obj_annotation(i,1)*2; %Have to multiply by 2 here(WTF!)
                y1 = obj_annotation(i,2)*2;
                width = obj_annotation(i,3);
                height = obj_annotation(i,4);
                
                %Show the frame
                frame = read(video_obj, frame_to_grab);
                if show
                    image(frame);
                    rectangle('Position',[x1 y1 width height], 'LineWidth',2, 'EdgeColor','b');
                end

                info_dat_output(fid,[x1 y1 width height],frame,count,obj_index);
            end
        end
    end
    
    % save('obj_annotation.mat','obj_annotation');
    close all;
    fclose all;
end

function info_dat_output(fid,bbox,frame,count,obj_index)
    label = {
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
    label = label';
    
    filename = sprintf('img/%s_%03d.jpg',label{obj_index},count);
    fprintf(fid, '%s 1 %d %d %d %d\n',filename,bbox(1,1),bbox(1,2),bbox(1,3),bbox(1,4));
    imwrite(frame, filename);
end