function FP_ADL_evaluation(file,video)
    activity_result = file_read(file);
    %activity_reuslt(5,2)
    
    load('action_table_complex.mat');
    load('action_counter_complex.mat');
    
    for i=1:size(activity_result,1)
        at_frame = activity_result(i,1);
        activity = activity_result(i,2);
        stage = activity_result(i,3);
        fprintf('%d %d %d\n',at_frame,activity,stage);
    end
end

function activity_result = file_read(name)
    
    fid = fopen(name);
    
    %00:08 00:33 12 1
    %00:59 01:30 12 2
    [A ,count] = fscanf(fid, '%d %d %d',[3 , inf]);
    
    activity_result = A';
    
    %fclose all;
end