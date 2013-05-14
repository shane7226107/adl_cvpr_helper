function dpm_translator()
    
    fprintf('\ndpm_translator\n\n');
    
    global obj_detection
    global obj_detection_count
                            %video, obj, count, info(x,y,width,height,active,score)
    obj_detection = -1*ones( 20,    89,  500,   6);
    obj_detection_count = zeros(20,89);
    
    %train set active
    path = '../ADL_detected_objects/trainset/active/';
    sub_dirs = subfolders(path);
    run_through_all_object_folders(path,sub_dirs);
    
%     %train set passive
%     path = '../ADL_detected_objects/trainset/passive/';
%     sub_dirs = subfolders(path);
%     run_through_all_object_folders(path,sub_dirs);
%     
%     %test set active
%     path = '../ADL_detected_objects/testset/active/';
%     sub_dirs = subfolders(path);
%     run_through_all_object_folders(path,sub_dirs);
%     
%     %test set passive
%     path = '../ADL_detected_objects/testset/passive/';
%     sub_dirs = subfolders(path);
%     run_through_all_object_folders(path,sub_dirs);

end

function subdir = subfolders(path)
    d = dir(path);
    isub = [d(:).isdir]; % returns logical vector indicates folders
    nameFolds = {d(isub).name}'; % folders only
    nameFolds(ismember(nameFolds,{'.','..'})) = []; %remove . and ..
    subdir = nameFolds;
end

function run_through_all_object_folders(parent,sub_dirs)    
    for obj=1:size(sub_dirs,1)
        fprintf('\n===%s===\n\n',[parent sub_dirs{obj}]);
        load_dpm_detection([parent sub_dirs{obj}]);
    end
end

function load_dpm_detection(path)
    %for video=1:20
    for video=1:1
        filepath = [path '/' sprintf('P_%02d.mat',video)];
        if (exist(filepath, 'file'))
            fprintf('%s\n',filepath);
            
            load(filepath);
            
            for i=1:size(frs,2)
                if(~isempty(boxes{i}))
                    sorted_boxes = nestedSortStruct(boxes{i}, 's');
                    %disp(sorted_boxes(1));
                    
                    %CHEK THIS PART LATER!!
                    %CHEK THIS PART LATER!!
                    %CHEK THIS PART LATER!!
                    score = sorted_boxes(1).s;
                    x = int32(sorted_boxes(1).xy(1));
                    y = int32(sorted_boxes(1).xy(2));
                    width = int32(sorted_boxes(1).xy(3) - x);
                    height = int32(sorted_boxes(1).xy(4) - y);
                    
                    fprintf('x:%04d y:%04d width:%04d height:%04d score:%f \n',x,y,width,height,score);
                end
            end
        end
    end 
end





