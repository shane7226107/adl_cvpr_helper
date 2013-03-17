function label_evaluation()
    listing = dir('label_0305');
    
    width_stds = [];
    width_in_mean_stds = [];
    width_in_median_stds = [];
    height_stds = [];
    height_in_mean_stds = [];
    height_in_median_stds = [];
    
    f_out_id = fopen(['label_0305/mean_std.txt'],'w');
    
%     figure();
%     hold on;
    
    for i=1:size(listing,1)
        
        if(strcmp(listing(i).name,'.') || strcmp(listing(i).name,'..') || strcmp(listing(i).name,'.DS_Store'))
            continue;
        end
        
        fprintf('processing : %s\n',listing(i).name);
        
        obj_annotation = file_read(listing(i).name);        
        
        width_mean = mean(obj_annotation(:,3));
        
        width_median = median(obj_annotation(:,3));
        
        height_mean = mean(obj_annotation(:,4));
        
        height_median = median(obj_annotation(:,4));
        
        width_std = std(obj_annotation(:,3));
        
        height_std = std(obj_annotation(:,4));
        
        %??????????,+-1?????data
        width_in_counter = 0;
        height_in_counter = 0;
        coeff = 1.5;
        length = size(obj_annotation(:,3),1);
        for j = 1:length
            if (obj_annotation(j,3) >= width_mean - coeff*width_std ) && (obj_annotation(j,3) <= width_mean + coeff*width_std )
                width_in_counter = width_in_counter + 1;
            end
            if (obj_annotation(j,4) >= height_mean - coeff*height_std ) && (obj_annotation(j,4) <= height_mean + coeff*height_std )
                height_in_counter = height_in_counter + 1;
            end
        end
        
        fprintf('Width=> mean:%f  std:%f\n  in_one_std:%f\n',width_mean,width_std,width_in_counter/length);
        fprintf('Height=> mean:%f  std:%f  in_one_std:%f\n\n\n',height_mean,height_std,height_in_counter/length);
        
        width_in_mean_stds = [width_in_mean_stds width_in_counter/length];
        height_in_mean_stds = [height_in_mean_stds height_in_counter/length];
        
        %???????????,+-2?????data
        width_in_counter = 0;
        height_in_counter = 0;
        length = size(obj_annotation(:,3),1);
        for j = 1:length
            if (obj_annotation(j,3) >= width_median - width_std ) && (obj_annotation(j,3) <= width_median + width_std )
                width_in_counter = width_in_counter + 1;
            end
            if (obj_annotation(j,4) >= height_median - height_std ) && (obj_annotation(j,4) <= height_median + height_std )
                height_in_counter = height_in_counter + 1;
            end
        end
        
        fprintf('Width=> mean:%f  std:%f\n  in_one_std:%f\n',width_mean,width_std,width_in_counter/length);
        fprintf('Height=> mean:%f  std:%f  in_one_std:%f\n\n\n',height_mean,height_std,height_in_counter/length);
        
        width_in_median_stds = [width_in_median_stds width_in_counter/length];
        height_in_median_stds = [height_in_median_stds height_in_counter/length];
%         mu=mean(obj_annotation(:,3));
%         sg=std(obj_annotation(:,3));
%         x=linspace(mu-4*sg,mu+4*sg,200);
%         pdfx=1/sqrt(2*pi)/sg*exp(-(x-mu).^2/(2*sg^2));
%         plot(x,pdfx,'g');
%         
%         mu=mean(obj_annotation(:,4));
%         sg=std(obj_annotation(:,4));
%         x=linspace(mu-4*sg,mu+4*sg,200);
%         pdfx=1/sqrt(2*pi)/sg*exp(-(x-mu).^2/(2*sg^2));
%         plot(x,pdfx,'b');
        
        width_stds = [width_stds width_std];
        height_stds = [height_stds height_std];
       
        fprintf(f_out_id,'%s %d %d %d %d\n',[listing(i).name '.xml'],int32(width_mean),int32(width_std),int32(height_mean),int32(height_std));
    end
    
%     hold off;
    
    figure
    hist(width_in_mean_stds)
    
    figure
    hist(height_in_mean_stds)
    
%     figure
%     hist(width_in_median_stds)
%     
%     figure
%     hist(height_in_median_stds)
    
end

function obj_annotation = file_read(name)
    
    fid = fopen(['label_0305/' name '/info_x_y_width_height.txt']);
    
    [A ,count] = fscanf(fid, '%d %d %d %d',[4 , inf]);
    
    obj_annotation = A';
    
    %fclose all;
end