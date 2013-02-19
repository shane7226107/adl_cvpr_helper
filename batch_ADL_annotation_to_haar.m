function batch_ADL_annotation_to_haar()
    total_count = ADL_annotation_to_haar(1, 4, true,true)
    total_count = ADL_annotation_to_haar(2, 4, true,true,total_count)
    total_count = ADL_annotation_to_haar(3, 4, true,true,total_count)
end