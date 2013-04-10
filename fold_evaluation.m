fold = 20;
num_class = 18;
avg_accuracy_total = [];
confusion_matrix_total = zeros(num_class,num_class);

for i = 1:fold
    %avg_accuracy = [avg_accuracy crf_evaluation(['cross_valid/result/unigram/fold_' int2str(i) '_result.txt'])];
    %[avg_accuracy confusion_matrix]= crf_evaluation(['cross_valid_complex/result/bigram/fold_' int2str(i) '_result.txt']);
    %[avg_accuracy confusion_matrix]= crf_evaluation(['cross_valid_1_vs_all/result/result_' int2str(i) '.txt']);
    %[avg_accuracy confusion_matrix]= crf_evaluation(['cross_valid_1_vs_all_more_segment/result/result_' int2str(i) '.txt']);
    [avg_accuracy confusion_matrix]= crf_evaluation(['cross_valid_1_vs_all_more_segment_2/result/result_' int2str(i) '.txt']);
    
    avg_accuracy_total = [avg_accuracy_total avg_accuracy];
    confusion_matrix_total = confusion_matrix_total + confusion_matrix;
end

avg = mean(avg_accuracy_total)

plot([avg_accuracy_total avg],'--rs','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','g',...
                'MarkerSize',10);

            action_list = {
            'combing_hair'
            'make_up'
            'brushing_teeth'
            'dental_floss'
            'washing_hands_face'
            'drying_hands_face'
%             'enter_leave_room'
%             'adjusting_thermostat'
            'laundry'
            'washing_dishes'
            'moving_dishes'
            'making_tea'
            'making_coffee'
            'drinking_water_bottle'
            'drinking_water_tap'
%             'making_hot_food'
            'making_cold_food_snack'
%             'eating_food_snack'
%             'mopping_in_kitchen'
            'vacuuming'
%             'taking_pills'
            'watching_tv'
            'using_computer'
            'using_cell'
%             'making_bed'
%             'cleaning_house'
%             'reading_book'
%             'using_mouth_wash'
%             'writing'
%             'putting_on_shoes_socks'
%             'drinking_coffee_tea'
%             'grabbing_water_from_tap'
    };
            

confusion_matrix_frac = zeros(num_class,num_class);

for ci=1:num_class
    for cj=1:num_class
        %c_start=sum(num_in_class(1:(ci-1)))+1;
        %c_end=sum(num_in_class(1:ci));
        %confusion_matrix(ci,cj)=size(find(predict_label(c_start:c_end)==cj),1)/num_in_class(ci);
        if sum(confusion_matrix_total(ci,:)) == 0
            confusion_matrix_frac(ci,cj) = 0;
        else
            confusion_matrix_frac(ci,cj) = confusion_matrix_total(ci,cj)/sum(confusion_matrix_total(ci,:));
        end
        
    end
end

draw_cm(confusion_matrix_frac,action_list,num_class);
