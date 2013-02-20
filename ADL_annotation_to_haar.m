
% Usage: 
%         video_index: index of CVPR12 dataset video clips
%         obj_index : index of CVPR12 dataset objects
%         show : display fiqure or not (boolean)
%         debug : debugging mode, break the program when 10 obejct annotation for haar created(boolean)
%
% example : ADL_annotation_to_haar(2,31,false, true)
% 
% obj_index : {
%               'bed': '1','book': '2','bottle':'3','cell':'4','dent_floss':'5',
%               'detergent':'6','dish':'7','door':'8','fridge':'9','kettle':'10',
%               'laptop':'11','microwave':'12','monitor':'13','pan':'14','pitcher':'15',
%               'soap_liquid':'16','tap':'17','tea_bag':'18','tooth_paste':'19','tv':'20',
%               'tv_remote':'21','mug/cup':'22','oven/stove':'23','person':'24','trash_can':'25',
%               'cloth':'26','knife/spoon/fork':'27','food/snack':'28','pills':'29','basket':'30',
%               'towel':'31','tooth_brush':'32','electric_keys':'33','container':'34','shoes':'35',
%               'cell_phone':'36','thermostat':'37','vacuum':'38','washer/dryer':'39','large_container':'40',
%               'keyboard':'41','blanket':'42','comb':'43','perfume':'44','milk/juice':'45',
%               'mop':'46'
%             }

function total_count = ADL_annotation_to_haar(video_index, obj_index, active_or_not, show ,debug ,total_count)
    if nargin < 6
        total_count = 0;
    end
    
    % total_count == 0 means we are creating a new info.dat
    if total_count == 0
        system('rm -r img');
        system('mkdir img');
    end
    
    fprintf('running ADL_annotation_to_haar_info\n');    
    
    obj_annotation = obj_annotation_read(video_index);
    total_count = grab_info_and_img(video_index ,obj_annotation ,obj_index ,active_or_not  ,show ,debug ,total_count);    
    
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
    fprintf('loading video...\n');
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

function total_count = grab_info_and_img(video_index, obj_annotation , obj_index, active_or_not , show ,debug, total_count)
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
    
    fprintf('Running through obj_annotaiton file...\n');
    for i=1:size(obj_annotation,1)
        
%         if(mod((i/size(obj_annotation,1) * 100),10) <= 0.002)
%             fprintf('%.2f..\n',i/size(obj_annotation,1));
%         end
        if mod(i,300) == 0
            fprintf('%d/%d  %.2f\n',i,size(obj_annotation,1),i/size(obj_annotation,1));
        end
        
        %Debug mode
        if debug && count > 10
            break;
        end
        
        %When finding required obj_index
        if (obj_index == obj_annotation(i,7)) && (active_or_not == obj_annotation(i,6))
            
            % Grab inter frames in each interval (out of 30 frames)
            % Setup frequency param here
            for j=0:10:30
                
                count = count + 1;
                
                %Debug mode
                if debug && count > 10
                    count = count - 1;
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
                
                %Making info.dat
                info_dat_output(fid,[x1 y1 width height],frame,active_or_not,count + total_count,obj_index);
            end
        end
    end
    
    % save('obj_annotation.mat','obj_annotation');
    close all;
    fclose all;
    
    total_count = count + total_count;
end

function info_dat_output(fid,bbox,frame,active_or_not,count,obj_index)
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
    
    if active_or_not
        state = 'active';
    else
        state = 'passive';
    end
    
    filename = sprintf('img/%s_%s_%03d.jpg',state,label{obj_index},count);
    fprintf(fid, '%s 1 %d %d %d %d\n',filename,bbox(1,1),bbox(1,2),bbox(1,3),bbox(1,4));
    imwrite(frame, filename);
end