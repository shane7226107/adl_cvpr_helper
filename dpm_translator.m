function dpm_translator()
    
    fprintf('\ndpm_translator\n\n');
    
                            %video, obj, count, info
    obj_detection = -1*ones( 20,    89,  500,   6);
    obj_detection_count = zeros(20,89);

%     for video=1:1
%         fprintf(' video : %d\n',video);
%         load('../')
%     end
    
    %testset active
    path = '../ADL_detected_objects/trainset/active/';
    sub_dirs = subfolders(path);
    run_through_all_object_folders(path,sub_dirs);
    
%     %testset passive    
%     subfolders('../ADL_detected_objects/trainset/passive/')
%     %train set active
%     subfolders('../ADL_detected_objects/testset/active/')
%     %train set passive
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
        fprintf('%s\n',[parent sub_dirs{obj}]);
    end
end