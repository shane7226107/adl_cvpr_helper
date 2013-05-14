function dpm_translator()
    
    fprintf('\ndpm_translator\n\n');
    
    global obj_detection
    global obj_detection_count
                            %video, obj, count, info
    obj_detection = -1*ones( 20,    89,  500,   6);
    obj_detection_count = zeros(20,89);
    
    %train set active
    path = '../ADL_detected_objects/trainset/active/';
    sub_dirs = subfolders(path);
    run_through_all_object_folders(path,sub_dirs);
    
%     %train set passive    
%     subfolders('../ADL_detected_objects/trainset/passive/')
%     %test set active
%     subfolders('../ADL_detected_objects/testset/active/')
%     %test set passive
%     subfolders('../ADL_detected_objects/testset/passive/')
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
    for video=1:20
        filepath = [path '/' sprintf('P_%02d.mat',video)];
        if (exist(filepath, 'file'))
            fprintf('%s\n',filepath);
        end
    end 
end





