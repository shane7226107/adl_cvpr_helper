function batch_FP_ADL_evaluation(FPN,thres_range)

precision_list_no_pyramid = [];
recall_list_no_pyramid = [];
precision_list_pyramid = [];
recall_list_pyramid = [];

for thres=thres_range
   
   %no pyramid
   [recall,precision] = FP_ADL_evaluation(thres,0,FPN);   
   precision_list_no_pyramid = [precision_list_no_pyramid precision];
   recall_list_no_pyramid = [recall_list_no_pyramid recall];   
   
   %with pyramid
   [recall,precision] = FP_ADL_evaluation(thres,1,FPN);   
   precision_list_pyramid = [precision_list_pyramid precision];
   recall_list_pyramid = [recall_list_pyramid recall];
   
end

%precision only
if 0
    plot(precision_list_no_pyramid,'-.s','Markersize',6,'MarkerFaceColor','k','LineWidth',3);

    hold all

    plot(precision_list_pyramid,'-.s','Markersize',6,'MarkerFaceColor','b','LineWidth',3);    
    
end


%recall only
if 0
    plot(recall_list_no_pyramid,'-.s','Markersize',6,'MarkerFaceColor','k','LineWidth',3);

    hold all

    plot(recall_list_pyramid,'-.s','Markersize',6,'MarkerFaceColor','b','LineWidth',3);
    
    
end

%both
if 1
    plot(recall_list_no_pyramid,precision_list_no_pyramid,'-.s','Markersize',6,'MarkerFaceColor','k','LineWidth',3);

    hold all

    plot(recall_list_pyramid ,precision_list_pyramid,'-rs','Markersize',6,'MarkerFaceColor','b','LineWidth',3);
    xlabel('Recall');
    ylabel('Precision');
end

end

