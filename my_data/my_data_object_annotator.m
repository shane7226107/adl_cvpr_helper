function my_data_object_annotator(start_frame)
    
    if nargin < 1
        start_frame = 1;
    end

    %video name
    video_name = 'P05.mp4';

    %output
    global f_id obj_list
    f_id = fopen([video_name '_label.txt'],'a');
    fprintf(f_id,'\n %s \n\n',datestr(now,'dd-mm-yyyy HH:MM:SS FFF'));
    
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
    'copier'
    };
    obj_list = obj_list';
    
    %Load video
    video_obj = video_load(['videos/' video_name]);   
    
    frame_index = int32(start_frame);
    hFig = figure;
    
    while 1
        frame = read(video_obj, frame_index);
        fprintf('%d/%d frames\n',frame_index,video_obj.NumberOfFrames);
        str = sprintf('%d/%d frames\n',frame_index,video_obj.NumberOfFrames);
        
        imshow(frame);
        text(10,30,str);
        set(0,'CurrentFigure',hFig);
        
        %command
        [x,y,key] = ginput(1);
        
        if key == 28
            fprintf('last frame\n');
            frame_index = frame_index - video_obj.FrameRate;
        elseif key == 29            
            fprintf('next frame\n');
            frame_index = frame_index + video_obj.FrameRate;
        elseif (key >= 48 && key <= 57) || (key == 99)
            
            if key == 99
                obj_index = 11;
            else
                obj_index = key-48;
            end
            
            if obj_index == 0
                obj_index = 10;
            end
            fprintf('obj : %d\n',obj_index);
            imshow(frame);
            %obj_name
            obj_name = obj_list{obj_index};
            %active or not
            [x,y,key] = ginput(1);
            
            %space to cancel
            if key ~= 32
                if key == 97
                    active = 1;
                    obj_index = obj_index + 10;
                else
                    active = 0;
                end

                str = sprintf('%d / %d frames\n active : %d obj : %d %s\n',frame_index,video_obj.NumberOfFrames,active,obj_index,obj_name);
                text(10,30,str);

                output(obj_index,active,frame_index);
            else
                fprintf('action canceled\n');
            end
        elseif key == 27
            fprintf('Quit\n');        
            break;
        else
            %do nothing
        end
    end
    
    clear all;
    close all;
    fclose all;
end

function output(obj_index,active,frame_index)
    global f_id
    
    [x,y,key] = ginput(2);
    %bounding range
    x = max(x,0);
    y = max(y,0);
    x = min(x,720);
    y = min(y,480);    
    
    str = sprintf('%d %d %d %d\n Y or N?',int32(x(1)),int32(y(1)),int32(x(2)),int32(y(2)));
    text(10,60,str);
    
    [x2,y2,key] = ginput(1);
    
    if key == 121
        fprintf(f_id,'%03d %03d %03d %03d %06d %d %d\n',int32(x(1)),int32(y(1)),int32(x(2)),int32(y(2)),int32(frame_index),active,int32(obj_index));
    else
        fprintf('action canceled\n');
    end
end

function video_obj = video_load(filename)
    fprintf('loading video...\n');
%     index_to_str = num2str(index, '%02d');
%     
%     %Machine depandent file format
%     if strcmp('GLNXA64',computer)
%         %Run in Ubuntu
%         filename = ['../../ADL_videos/raw/AVI/P_' index_to_str '.avi'];
%     else
%         %Run in Mac
%         filename = ['../../ADL_videos/P_' index_to_str '.MP4'];
%     end    
    
    video_obj = VideoReader(filename);
    
    fprintf('%s\n',filename);
    fprintf('FrameRate: %d\n',video_obj.FrameRate);
    fprintf('NumberOfFrames: %d\n',video_obj.NumberOfFrames);
end

% keys
% left : 28
% right : 29
% numbers #0~#9 : 48~57



