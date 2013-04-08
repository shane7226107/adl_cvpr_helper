function FP_ADL_evaluation(file,video)
    activity_result = file_read(file);
    %activity_reuslt(5,2)
    
    activities_total = size(activity_result,1);
    activities_accurate = 0;
    
    a = load('action_table_complex.mat');
    b = load('action_table.mat');
    a.action_table;
    b.action_table(:,6,:) = 0;
    action_table = a.action_table + b.action_table;
    
    c = load('action_counter_complex.mat');
    d = load('action_counter.mat');
    action_counter = c.action_counter + d.action_counter;
    
    for i=1:size(activity_result,1)
        
        at_frame = activity_result(i,1);
        action_index = activity_result(i,2);
        stage = activity_result(i,3);
        fprintf('%d %d %d\n',at_frame,action_index,stage);
        
        if action_index == -1
            %Add one into accurate first.
            activities_accurate = activities_accurate + 1;
            
            %Check all the actions, if there is any one happended in this
            %interval, minus one from accurate
            for k=1:32
                break_flag = 0;
                for j=1:action_counter(1,k)

                    m_start = action_table(j,1,k);
                    sec_start = action_table(j,2,k);
                    m_end = action_table(j,3,k);
                    sec_end = action_table(j,4,k);

                    %Approximation here..   
                    fps = 30;
                    start_frame = round(m_start*60*fps + sec_start*fps);
                    end_frame = round(m_end*60*fps + sec_end*fps);

                    if at_frame >= start_frame && at_frame <= end_frame
                       activities_accurate = activities_accurate - 1;
                       break_flag = 1;
                       break;
                    end
                end
                
                if break_flag
                    break;
                end
            end
        else
            for j=1:action_counter(1,action_index)
            
                m_start = action_table(j,1,action_index);
                sec_start = action_table(j,2,action_index);
                m_end = action_table(j,3,action_index);
                sec_end = action_table(j,4,action_index);

                %Approximation here..   
                fps = 30;
                start_frame = round(m_start*60*fps + sec_start*fps);
                end_frame = round(m_end*60*fps + sec_end*fps);

                if at_frame >= start_frame && at_frame <= end_frame
                   activities_accurate = activities_accurate + 1;
                   break;
                end
            end
        end
    end
    
    
    fprintf('Precision: %f  %d/%d\n', activities_accurate/activities_total , activities_accurate , activities_total);
end

function activity_result = file_read(name)
    
    fid = fopen(name);
    
    %00:08 00:33 12 1
    %00:59 01:30 12 2
    [A ,count] = fscanf(fid, '%d %d %d',[3 , inf]);
    
    activity_result = A';
    
    %fclose all;
end