function dpm_translator()
    
    fprintf('\ndpm_translator\n\n');
    
    global obj_detection
    global obj_detection_count
    global current_obj_name
    global current_obj_active
    
                            %video, obj, count, info(x,y,width,height,active,score)
    obj_detection = -1*ones( 20,    89,  500,   6);
    obj_detection_count = zeros(20,89);
    
    %train set active
    path = '../ADL_detected_objects/trainset/active/';
    sub_dirs = subfolders(path);
    run_through_all_object_folders(path,sub_dirs);
    current_obj_active = true;
    
%     %train set passive
%     path = '../ADL_detected_objects/trainset/passive/';
%     sub_dirs = subfolders(path);
%     run_through_all_object_folders(path,sub_dirs);
%     
%     %test set active
%     path = '../ADL_detected_objects/testset/active/';
%     sub_dirs = subfolders(path);
%     run_through_all_object_folders(path,sub_dirs);
%     
%     %test set passive
%     path = '../ADL_detected_objects/testset/passive/';
%     sub_dirs = subfolders(path);
%     run_through_all_object_folders(path,sub_dirs);

end

function subdir = subfolders(path)
    d = dir(path);
    isub = [d(:).isdir]; % returns logical vector indicates folders
    nameFolds = {d(isub).name}'; % folders only
    nameFolds(ismember(nameFolds,{'.','..'})) = []; %remove . and ..
    subdir = nameFolds;
end

function run_through_all_object_folders(parent,sub_dirs)
    
    global current_obj_name
    
    for obj=1:size(sub_dirs,1)
        fprintf('\n===%s===\n\n',[parent sub_dirs{obj}]);
        current_obj_name = sub_dirs{obj};
        load_dpm_detection([parent sub_dirs{obj}]);
    end
end

function load_dpm_detection(path)
    
    global current_obj_name current_obj_active
    
    %for video=1:20
    for video=1:1
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
                    score = sorted_boxes(1).s;
                    x = int32(sorted_boxes(1).xy(1));
                    y = int32(sorted_boxes(1).xy(2));
                    width = int32(sorted_boxes(1).xy(3) - x);
                    height = int32(sorted_boxes(1).xy(4) - y);
                    
                    fprintf('\n %s active:%d\n',current_obj_name,current_obj_active);
                    fprintf('x:%04d y:%04d width:%04d height:%04d score:%f \n\n',x,y,width,height,score);
                end
            end
        end
    end 
end

function obj_index = get_obj_index(name)

list = {
    'bed' 'book' 'bottle' 'cell' 'dent_floss' 
    'detergent' 'dish' 'door' 'fridge' 'kettle' 
    'laptop' 'microwave' 'monitor' 'pan' 'pitcher' 
    'soap_liquid' 'tap' 'tea_bag' 'tooth_paste' 'tv' 
    'tv_remote' 'mug_cup' 'oven_stove' 'person' 'trash_can' 
    'cloth' 'knife_spoon_fork' 'food_snack' 'pills' 'basket' 
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

obj_index = -1;

for i=1:89
    if strcmp(list{i},name)
        obj_index = i;
    end
end

end


