function batch_FP_ADL_evaluation(FPN,thres_range)

precision_list_no_pyramid = [];
recall_list_no_pyramid = [];
precision_list_pyramid = [];
recall_list_pyramid = [];

for thres=thres_range
    
   [recall,precision] = FP_ADL_evaluation(thres,0,FPN);
   precision_list_no_pyramid = [precision_list_no_pyramid precision];
   recall_list_no_pyramid = [recall_list_no_pyramid recall];
   
   [recall,precision] = FP_ADL_evaluation(thres,1,FPN);
   precision_list_pyramid = [precision_list_pyramid precision];
   recall_list_pyramid = [recall_list_pyramid recall];
   
end

plot(precision_list_no_pyramid,'-.s','Markersize',6,'MarkerFaceColor','k','LineWidth',3);

hold all

plot(precision_list_pyramid,'-.s','Markersize',6,'MarkerFaceColor','b','LineWidth',3);

% plot(recall_list_no_pyramid,'-.s','Markersize',6,'MarkerFaceColor','k','LineWidth',3);
% 
% hold all
% 
% plot(recall_list_pyramid,'-.s','Markersize',6,'MarkerFaceColor','b','LineWidth',3);


% plot(recall_list_no_pyramid,precision_list_no_pyramid,'-.s','Markersize',6,'MarkerFaceColor','k','LineWidth',3);
%         
% hold all
% 
% plot(recall_list_pyramid ,precision_list_pyramid,'-rs','Markersize',6,'MarkerFaceColor','b','LineWidth',3);
% 
% xlabel('Recall');
% ylabel('Precision');

end

