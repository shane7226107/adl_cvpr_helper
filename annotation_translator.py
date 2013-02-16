print "\n\nProgram Begins\n\n"

index = 20
filepath = '../ADL_annotations/object_annotation/object_annot_P_' + str(index).zfill(2) + '.txt'
filepath_out = '../ADL_annotations/object_annotation/object_annot_P_' + str(index).zfill(2) + '_translated.txt'
print filepath
f_in_id = open(filepath,'r')
f_out_id = open(filepath_out,'w')

label = {'bed': '1','book': '2','bottle':'3','cell':'4','dent_floss':'5',
		 'detergent':'6','dish':'7','door':'8','fridge':'9','kettle':'10',
		 'laptop':'11','microwave':'12','monitor':'13','pan':'14','pitcher':'15',
		 'soap_liquid':'16','tap':'17','tea_bag':'18','tooth_paste':'19','tv':'20',
		 'tv_remote':'21','mug/cup':'22','oven/stove':'23','person':'24','trash_can':'25',
		 'cloth':'26','knife/spoon/fork':'27','food/snack':'28','pills':'29','basket':'30',
		 'towel':'31','tooth_brush':'32','electric_keys':'33','container':'34','shoes':'35',
		 'cell_phone':'36','thermostat':'37','vacuum':'38','washer/dryer':'39','large_container':'40',
		 'keyboard':'41','blanket':'42','comb':'43','perfume':'44','milk/juice':'45',
		 'mop':'46'	
		 }

splited_line = []

while True:
    #Grab sentences and their structures             
    line_structure = f_in_id.readline()

    if len(line_structure) == 0:
        break
    line_structure = line_structure.replace('elec_keys','electric_keys')
    line_structure = line_structure.replace('shoe','shoes')
    line_structure = line_structure.replace('shoess','shoes')
    #Split the structure by space
    line_split = line_structure.split(' ')
    #Remove the '\n' in the structure
    line_split[len(line_split) - 1] = line_split[len(line_split) - 1].replace('\n' , '')
    #print (line_split)
    splited_line.append(line_split)


for index in range(len(splited_line)):
    print splited_line[index]
    for x in range(1,7):
    	f_out_id.write(splited_line[index][x]+' ')
    f_out_id.write(label[splited_line[index][7]]+' ')
    f_out_id.write('\n')
	
f_in_id.close();
f_out_id.close();

print "\n\nProgram Ended\n\n"