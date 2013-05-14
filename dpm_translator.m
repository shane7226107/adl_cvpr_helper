function dpm_translator()
    
    fprintf('\ndpm_translator\n\n');
    
    global obj_detection
    global obj_detection_count
                            %video, obj, count, info(x,y,width,height,active,score)
    obj_detection = -1*ones( 20,    89,  500,   6);
    obj_detection_count = zeros(20,89);
    
    %train set active
    path = '../ADL_detected_objects/trainset/active/';
    %sub_dirs = subfolders(path);
    %run_through_all_object_folders(path,sub_dirs);
    obj_index = get_obj_index('123');
    
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
    for obj=1:size(sub_dirs,1)
        fprintf('\n===%s===\n\n',[parent sub_dirs{obj}]);
        load_dpm_detection([parent sub_dirs{obj}]);
    end
end

function load_dpm_detection(path)
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
                    
                    fprintf('x:%04d y:%04d width:%04d height:%04d score:%f \n',x,y,width,height,score);
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
};

list=list'

list{54}

obj_index = 1;

% 56 : active_tooth_brush
% 57 : active_tooth_paste
% 58 : active_tv_remote
% 59 : active_container
% 60 : active_trash_can
% 61 : active_mug_cup
% 62 : active_tea_bag
% 63 : active_soap_liquid
% 64 : active_laptop
% 65 : active_door
% 66 : active_towel
% 67 : active_thermostat
% 68 : active_pan
% 69 : active_cell_phone
% 70 : active_person
% 71 : active_dent_floss
% 72 : active_vacuum
% 73 : active_kettle
% 74 : active_pitcher
% 75 : active_detergent
% 76 : active_washer_dryer
% 77 : active_cell
% 78 : active_book
% 79 : active_shoes
% 80 : active_cloth
% 81 : active_comb
% 82 : active_electric_keys
% 83 : active_tv
% 84 : active_milk_juice
% 85 : active_basket
% 86 : active_large_container
% 87 : active_mop
% 88 : active_bed
% 89 : active_blanket
end


