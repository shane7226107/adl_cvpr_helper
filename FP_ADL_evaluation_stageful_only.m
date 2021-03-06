function precision = FP_ADL_evaluation_stageful_only(file,video,thres)

    prob_threshold = thres;
    
    activity_result = file_read(file);
    
    activities_total = size(activity_result,1);
    activities_accurate = 0;
    
    a = load('action_table_complex.mat');
    b = load('action_table.mat');
    a.action_table;
    b.action_table(:,6,:) = 0;
    
    c = load('action_counter_complex.mat');
    d = load('action_counter.mat');
    
    ignore = 0;
    
    for i=1:size(activity_result,1)
        
        at_frame = activity_result(i,1)+ 150;
        action_index = activity_result(i,2);
        stage = activity_result(i,3);
        prob = activity_result(i,4);
        fprintf('%d %d %d %f\n',at_frame,action_index,stage, prob);
        
%         %Non-stageful filter
%         if stage == 0
%            ignore = ignore + 1;
%            fprintf('skipped\n');
%            continue; 
%         end

        %Multi-stage only
        muti_stages = [9 12 13 16];

        if isempty(find(muti_stages==action_index,1))
            ignore = ignore + 1;
            fprintf('skipped\n');
            continue; 
        end
        
        %Prob threshold
        if prob < prob_threshold
            ignore = ignore + 1;
            fprintf('skipped\n');
            continue;
        end
        
        if action_index == -1
            %Add one into accurate first.
            activities_accurate = activities_accurate + 1;
            
            %Check all the actions, if there is any one happended in this
            %interval, minus one from accurate count
            for k=1:32
                
                break_flag = 0;
                
                for j=1:c.action_counter(1,k)

                    m_start = a.action_table(j,1,k);
                    sec_start = a.action_table(j,2,k);
                    m_end = a.action_table(j,3,k);
                    sec_end = a.action_table(j,4,k);
                    video_index = a.action_table(j,5,k);

                    %Approximation here..
                    fps = 30;
                    start_frame = round(m_start*60*fps + sec_start*fps);
                    end_frame = round(m_end*60*fps + sec_end*fps);

                    if at_frame >= start_frame && at_frame <= end_frame && video_index == video
                       activities_accurate = activities_accurate - 1;
                       break_flag = 1;
                       break;
                    end
                end
                
                if break_flag
                    break;
                end
                
                for j=1:d.action_counter(1,k)

                    m_start = b.action_table(j,1,k);
                    sec_start = b.action_table(j,2,k);
                    m_end = b.action_table(j,3,k);
                    sec_end = b.action_table(j,4,k);
                    video_index = b.action_table(j,5,k);

                    %Approximation here..   
                    fps = 30;
                    start_frame = round(m_start*60*fps + sec_start*fps);
                    end_frame = round(m_end*60*fps + sec_end*fps);

                    if at_frame >= start_frame && at_frame <= end_frame && video_index == video
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
            
            break_flag = 0;
            
            for j=1:c.action_counter(1,action_index)
            
                m_start = a.action_table(j,1,action_index);
                sec_start = a.action_table(j,2,action_index);
                m_end = a.action_table(j,3,action_index);
                sec_end = a.action_table(j,4,action_index);
                video_index = a.action_table(j,5,action_index);
                
                %Approximation here..   
                fps = 30;
                start_frame = round(m_start*60*fps + sec_start*fps);
                end_frame = round(m_end*60*fps + sec_end*fps);

                if at_frame >= start_frame && at_frame <= end_frame && video == video_index
                   activities_accurate = activities_accurate + 1;
                   break_flag = 1;
                   break;
                end
            end
            
            for j=1:d.action_counter(1,action_index)
                
                if break_flag
                    break;
                end
                
                m_start = b.action_table(j,1,action_index);
                sec_start = b.action_table(j,2,action_index);
                m_end = b.action_table(j,3,action_index);
                sec_end = b.action_table(j,4,action_index);
                video_index = b.action_table(j,5,action_index);
                
                %Approximation here..   
                fps = 30;
                start_frame = round(m_start*60*fps + sec_start*fps);
                end_frame = round(m_end*60*fps + sec_end*fps);

                if at_frame >= start_frame && at_frame <= end_frame && video == video_index
                   activities_accurate = activities_accurate + 1;
                   break;
                end
            end
        end
    end
    
    if activities_total-ignore == 0
        precision = -1;
    else
        precision = activities_accurate/(activities_total-ignore);
    end
    
    fprintf('Precision: %f  %d/%d\n', precision , activities_accurate , (activities_total-ignore));
                
end

function activity_result = file_read(name)
    
    fid = fopen(name);
    
    %00:08 00:33 12 1
    %00:59 01:30 12 2
    [A ,count] = fscanf(fid, '%d %d %d %f',[4 , inf]);
    
    activity_result = A';
    
    fclose all;
end