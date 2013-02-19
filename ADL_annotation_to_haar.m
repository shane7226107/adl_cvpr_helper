function ADL_annotation_to_haar(video_index, obj_index, show)
    fprintf('running ADL_annotation_to_haar_info\n');
    
    obj_annotation = obj_annotation_read(video_index);
    grab_info_and_img(video_index, obj_annotation, obj_index , show);    
    
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

function grab_info_and_img(video_index, obj_annotation , obj_index , show)
    fprintf('grabbing img and output info.dat...\n');
    video_obj = video_load(video_index);
    
    fid = fopen('info.dat','w');
    
    if show 
        figure;
    end
    
    count = 0;
    
    for i=1:size(obj_annotation,1)
        %When finding required obj_index
        if obj_index == obj_annotation(i,7)
         
            count = count + 1;
            
            %Avoiding to crash at frame 0
            frame_to_grab = obj_annotation(i,5);
            if obj_annotation(i,5) == 0
              frame_to_grab = obj_annotation(i,5)+1;  
            end
 
            %show the frame
            if show
                frame = read(video_obj, frame_to_grab);
                image(frame);
                x1 = obj_annotation(i,1)*2; %Have to multiply by 2 here(WTF)
                y1 = obj_annotation(i,2)*2;
                width = obj_annotation(i,3);
                height = obj_annotation(i,4);
                rectangle('Position',[x1 y1 width height], 'LineWidth',2, 'EdgeColor','b');
            end
            
            info_dat_output(fid,[x1 y1 width height],count);
        end
    end
    
    % save('obj_annotation.mat','obj_annotation');
    close all;
    fclose all;
end

function info_dat_output(fid,bbox,count)
    fprintf(fid, 'img/%03d.jpg 1 %d %d %d %d \n',count,bbox(1,1),bbox(1,2),bbox(1,3),bbox(1,4));    
end