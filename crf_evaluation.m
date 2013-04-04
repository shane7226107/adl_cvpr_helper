function score = crf_evaluation(filename)
    fprintf('crf_evaluation\n');
    
    lines = read(filename);
    
    acc_counter = 0;
    
    num_lines = size(lines{1},1)
    
    for i=1:num_lines
        fprintf('%d : %s %s\n',i,lines{1,90}{i},lines{1,91}{i});
        str1 = lines{1,90}{i};
        str2 = lines{1,91}{i};
        if strcmp(str1,str2)
            acc_counter = acc_counter + 1;
        end
    end
    
    score = acc_counter/num_lines;
    
    fprintf('accuracy: %f\n', score);
end

function lines = read(file_name)
    f_id = fopen(file_name);
    % I know it is stupid...
    lines = textscan(f_id,'%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %s %s');
    
    fclose all;
end