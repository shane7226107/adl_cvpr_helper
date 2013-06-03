function my_data_action_annotator(start_frame)
    
    if nargin < 1
        start_frame = 1;
    end

    %video name
    video_name = 'P05.mp4';
    
    [    ]????

[    ]????

[    ]??

[    ]??( ?????????)

[    ]????

[    ]???

[    ]??

Multi-stage activities:

???  [    ]??????(??????)  -> [    ]?????

?? [     ]???? -> [    ]????? -> [    ]????
    
    %output
    global f_id action_list
    f_id = fopen([video_name '_label.txt'],'a');
    fprintf(f_id,'\n %s \n\n',datestr(now,'dd-mm-yyyy HH:MM:SS FFF'));
    
    %action_list
    %{            
        1 : use_computer
        2 : use_cell
        3 : wash_hand
        4 : drink_water
        5 : talk_to_people
        6 : check_the_weather
        7 : reading
        8 : beverage_stage_1
        9 : beverage_stage_2
        10: copy_documents_stage_1
        11: copy_documents_stage_2
        12: copy_documents_stage_3
    %}

    action_list = {          
        'use_computer'
        'use_cell'
        'wash_hand'
        'drink_water'
        'talk_to_people'
        'check_the_weather'
        'reading'
        'beverage_stage_1'
        'beverage_stage_2'
        'copy_documents_stage_1'
        'copy_documents_stage_2'
        'copy_documents_stage_3'
    };
    action_list = action_list';
    
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



