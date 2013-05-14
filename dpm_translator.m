function dpm_translator()
    

%     for video=1:1
%         fprintf(' video : %d\n',video);
%         load('../')
%     end
    
    %testset active
    subfolders('../ADL_detected_objects/trainset/active/')
    %testset passive    
    subfolders('../ADL_detected_objects/trainset/passive/')
    %train set active
    subfolders('../ADL_detected_objects/testset/active/')
    %train set passive
    subfolders('../ADL_detected_objects/testset/passive/')
end

function subdir = subfolders(path)
    d = dir(path);
    isub = [d(:).isdir]; % returns logical vector indicates folders
    nameFolds = {d(isub).name}'; % folders only
    nameFolds(ismember(nameFolds,{'.','..'})) = []; %remove . and ..
    subdir = nameFolds;
end