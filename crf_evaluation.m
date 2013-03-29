function crf_evaluation()
    fprintf('crf_evaluation\n');
    
    lines = read('out_7_20.txt');
    
    size(lines)
    
    acc_counter = 0;
    
    for i=1:size(lines,2)
        fprintf('%d : %s %s\n',i,lines{1,90}{i},lines{1,91}{i});
        str1 = lines{1,90}{i};
        str2 = lines{1,91}{i};
        if strcmp(str1,str2)
            acc_counter = acc_counter + 1;
        end
    end
    
    fprintf('accuracy: %f\n', acc_counter/size(lines,2));
        
    save('lines.mat','lines');
end

function lines = read(file_name)
    f_id = fopen(file_name);
    % I know it is stupid...
    lines = textscan(f_id,'%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %s %s');
    
    fclose all;
end