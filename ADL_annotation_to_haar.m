function ADL_annotation_to_haar()
    fprintf('running ADL_annotation_to_haar\n');
    %obj_annotation = obj_annotation_read(1);
    video_frame = video_load(3,3);
end

function obj_annotation = obj_annotation_read(index)
    fprintf('reading: %s\n', filename);
    index_to_str = num2str(index, '%02d');
    filename = ['../ADL_annotations/object_annotation/object_annot_P_' index_to_str '_translated.txt'];
        
    fid = fopen(filename);
    
    [A ,count] = fscanf(fid, '%d %d %d %d %d %d %d',[7 , inf]);
    obj_annotation = A';
    
    fclose all;
    fprintf('finished reading annotation file\n');
end

function video_frame = video_load(index,frame)
    fprintf('reading video...\n');
    index_to_str = num2str(index, '%02d');
    filename = ['../ADL_videos/P_' index_to_str '.MP4'];
    
    xyloObj = VideoReader(filename);

    nFrames = xyloObj.NumberOfFrames;
    vidHeight = xyloObj.Height;
    vidWidth = xyloObj.Width;
    
    % Preallocate movie structure.
    mov(1:nFrames) = ...
        struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
               'colormap', []);

    % Read one frame at a time.
    % for k = 1 : nFrames
    %    mov(k).cdata = read(xyloObj, k);
    % end
    
    % Size a figure based on the video's width and height.
    % hf = figure;
    % set(hf, 'position', [150 150 vidWidth vidHeight])

    % Play back the movie once at the video's frame rate.
    % movie(hf, mov, 1, xyloObj.FrameRate);
    
    % image(mov(1).cdata);
    % video_frames = mov;
    video_frame = read(xyloObj, frame);
end