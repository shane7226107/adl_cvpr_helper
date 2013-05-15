function dpm_translator(load_detection_mat)
    
    fprintf('\ndpm_translator\n\n');
    
    global obj_detection
    global obj_detection_count
    global current_obj_name
    global current_obj_active
    global list
    
    list = {
        'bed' 'book' 'bottle' 'cell' 'dent_floss' %5
        'detergent' 'dish' 'door' 'fridge' 'kettle' %10
        'laptop' 'microwave' 'monitor' 'pan' 'pitcher' %15
        'soap_liquid' 'tap' 'tea_bag' 'tooth_paste' 'tv' %20
        'tv_remote' 'mug_cup' 'oven_stove' 'person' 'trash_can' %25 
        'cloth' 'knife_spoon_fork' 'food_snack' 'pills' 'basket'%30
        'towel' 'tooth_brush' 'electric_keys' 'container' 'shoes' 
        'cell_phone' 'thermostat' 'vacuum' 'washer_dryer' 'large_container' 
        'keyboard' 'blanket' 'comb' 'perfume' 'milk_juice' 
        'mop' 'active_fridge' 'active_bottle' 'active_dish' 'active_knife_spoon_fork' 
        'active_food_snack' 'active_microwave' 'active_oven_stove' 'active_tap' 'active_pills' %55
        'active_tooth_brush' 'active_tooth_paste' 'active_tv_remote' 'active_container' 'active_trash_can' %60
        'active_mug_cup' 'active_tea_bag' 'active_soap_liquid' 'active_laptop' 'active_door' %65
        'active_towel' 'active_thermostat' 'active_pan' 'active_cell_phone' 'active_person' %70
        'active_dent_floss' 'active_vacuum' 'active_kettle' 'active_pitcher' 'active_detergent'%75
        'active_washer_dryer' 'active_cell' 'active_book' 'active_shoes' 'active_cloth' %80
        'active_comb' 'active_electric_keys' 'active_tv' 'active_milk_juice' 'active_basket' %85
        'active_large_container' 'active_mop' 'active_bed' 'active_blanket' 'dump_element' %90
    };

    list=list';
    
                            %video, obj, count, info(x,y,width,height,active,score)
    obj_detection = -1*ones( 20,    89,  500,   7);
    obj_detection_count = zeros(20,89);
   
    if load_detection_mat
        %train set active
        current_obj_active = true;
        path = '../ADL_detected_objects/trainset/active/';
        sub_dirs = subfolders(path);
        run_through_all_object_folders(path,sub_dirs);

        %train set passive
        current_obj_active = false;
        path = '../ADL_detected_objects/trainset/passive/';
        sub_dirs = subfolders(path);
        run_through_all_object_folders(path,sub_dirs);

        %test set active
        current_obj_active = true;
        path = '../ADL_detected_objects/testset/active/';
        sub_dirs = subfolders(path);
        run_through_all_object_folders(path,sub_dirs);

        %test set passive
        current_obj_active = false;
        path = '../ADL_detected_objects/testset/passive/';
        sub_dirs = subfolders(path);
        run_through_all_object_folders(path,sub_dirs);

        save('dpm_obj_detection.mat', 'obj_detection');
        save('dpm_obj_detection_count.mat', 'obj_detection_count');
    else
        %Output txt
        load 'dpm_obj_detection.mat';
        load 'dpm_obj_detection_count.mat';
        
        for i=1:20
            output(i);
        end
    end
    
    

end

function subdir = subfolders(path)
    d = dir(path);
    isub = [d(:).isdir]; % returns logical vector indicates folders
    nameFolds = {d(isub).name}'; % folders only
    nameFolds(ismember(nameFolds,{'.','..'})) = []; %remove . and ..
    subdir = nameFolds;
end

function run_through_all_object_folders(parent,sub_dirs)
    
    global current_obj_name current_obj_active
    
    for obj=1:size(sub_dirs,1)
        fprintf('\n===%s===\n\n',[parent sub_dirs{obj}]);
        
        if current_obj_active
            current_obj_name = ['active_' sub_dirs{obj}];
        else
            current_obj_name = sub_dirs{obj};
        end
        
        load_dpm_detection([parent sub_dirs{obj}]);
    end
end

function load_dpm_detection(path)
    
    global current_obj_name current_obj_active obj_detection obj_detection_count
    
    for video=1:20
    %for video=1:1
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
                    
                    x1 = int32(sorted_boxes(1).xy(1));
                    y1 = int32(sorted_boxes(1).xy(2));
                    x2 = int32(sorted_boxes(1).xy(3));
                    y2 = int32(sorted_boxes(1).xy(4));
                    frame = int32(frs(i));
                    obj_index = get_obj_index(current_obj_name);                    
                    score = sorted_boxes(1).s;
                    
                    %fprintf('\n %s active:%d\n',current_obj_name,current_obj_active);
                    %fprintf('x:%04d y:%04d width:%04d height:%04d score:%f \n\n',x,y,width,height,score);
                    
                    obj_detection_count(video,obj_index) = obj_detection_count(video,obj_index) + 1;
                    
                    obj_detection(video, obj_index ,obj_detection_count(video,obj_index), 1) = x1;
                    obj_detection(video, obj_index ,obj_detection_count(video,obj_index), 2) = y1;
                    obj_detection(video, obj_index ,obj_detection_count(video,obj_index), 3) = x2;
                    obj_detection(video, obj_index ,obj_detection_count(video,obj_index), 4) = y2;
                    obj_detection(video, obj_index ,obj_detection_count(video,obj_index), 5) = frame;
                    obj_detection(video, obj_index ,obj_detection_count(video,obj_index), 6) = current_obj_active;
                    obj_detection(video, obj_index ,obj_detection_count(video,obj_index), 7) = score;                    
                end
            end
            
            clear frs;
            clear boxes;
          
        end
    end 
end

function output(video)
    global obj_detection obj_detection_count
    
    fprintf(' === Output video %d === \n',video);
    
    filepath = sprintf('dpm_obj_detection/P_%02d.txt',video);
    fid = fopen(filepath,'w');
    
    for obj_index=1:89
        for i=1:obj_detection_count(video,obj_index)
            x1 = obj_detection(video, obj_index ,i, 1);
            y1 = obj_detection(video, obj_index ,i, 2);
            x2 = obj_detection(video, obj_index ,i, 3);
            y2 = obj_detection(video, obj_index ,i, 4);
            frame = obj_detection(video, obj_index ,i, 5);
            active = obj_detection(video, obj_index ,i, 6);
            score = abs(obj_detection(video, obj_index ,i, 7));
            
            fprintf(fid,'%04d %04d %04d %04d %08d %d %d %f %s\n',x1,y1,x2,y2,frame,active,obj_index,score,get_obj_name(obj_index));
        end
    end
    
    fclose all;
end

function obj_index = get_obj_index(name)

global list

obj_index = -1;

for i=1:89
    if strcmp(list{i},name)
        obj_index = i;
    end
end

end

function obj_name = get_obj_name(index)

global list

obj_name = list{index};

end


