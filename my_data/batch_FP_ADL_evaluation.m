function batch_FP_ADL_evaluation(FPN,thres_range)

precision_list_no_pyramid = [0];
recall_list_no_pyramid = [1];
precision_list_pyramid = [0];
recall_list_pyramid = [1];

for thres=thres_range
   
   fprintf('thres = %f\n',thres); 
    
   %no pyramid
   [recall,precision] = FP_ADL_evaluation(thres,0,FPN);   
   precision_list_no_pyramid = [precision_list_no_pyramid precision];
   recall_list_no_pyramid = [recall_list_no_pyramid recall];   
   
   %with pyramid
   [recall,precision] = FP_ADL_evaluation(thres,1,FPN);   
   precision_list_pyramid = [precision_list_pyramid precision];
   recall_list_pyramid = [recall_list_pyramid recall];
   
end

precision_list_no_pyramid = [precision_list_no_pyramid 1];
recall_list_no_pyramid = [recall_list_no_pyramid 0];   
precision_list_pyramid = [precision_list_pyramid 1];
recall_list_pyramid = [recall_list_pyramid 0];


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

