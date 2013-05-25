function my_data_object_annotator
    
    %Load video
     video_obj = video_load('videos/P01.mp4');

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
    
    fprintf('%s\n',filename);
    xyloObj = VideoReader(filename);

    video_obj = xyloObj;
end