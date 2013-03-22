import os

#sub-routine used for appending log msgs
def append_log(p,log):
        while 1:
                line = p.readline()
                if not line: break
                log.append(line)
        return log

def inverse_lookup(dict,value):
        for key in dict:
                if dict[key] == value:
                        return key

        return 'NO_SUCH_KEY_VALUE_PAIR'

print 'Label translate with obj index...\n\n'

obj_index_dict = {
              'bed': '1','book': '2','bottle':'3','cell':'4','dent_floss':'5',
              'detergent':'6','dish':'7','door':'8','fridge':'9','kettle':'10',
              'laptop':'11','microwave':'12','monitor':'13','pan':'14','pitcher':'15',
              'soap_liquid':'16','tap':'17','tea_bag':'18','tooth_paste':'19','tv':'20',
              'tv_remote':'21','mug_cup':'22','oven_stove':'23','person':'24','trash_can':'25',
              'cloth':'26','knife_spoon_fork':'27','food_snack':'28','pills':'29','basket':'30',
              'towel':'31','tooth_brush':'32','electric_keys':'33','container':'34','shoes':'35',
              'cell_phone':'36','thermostat':'37','vacuum':'38','washer_dryer':'39','large_container':'40',
              'keyboard':'41','blanket':'42','comb':'43','perfume':'44','milk_juice':'45',
              'mop':'46'
            }

os.chdir("ADL_annotations/object_annotation/translated")
for files in os.listdir("."):
    if files.endswith(".txt"):
        print files
        #read file
        f_in_id = open(files,'r')

        f_out_id = open('../translated_with_obj_name/'+files.replace('.txt','')+'_with_obj_name.txt','w')

        while True:
                line = f_in_id.readline().replace('\n','')

                if len(line) == 0:break

                #print line
                line_split  = line.split(" ")

                obj_name = inverse_lookup(obj_index_dict,line_split[6])

                #passive
                if line_split[5] == '0':
                    obj_name = obj_name
                #active
                else:
                    obj_name = 'active_' + obj_name
                    #whether we need to append the dictionary
                    if obj_name not in obj_index_dict:
                        line_split[6] = str(len(obj_index_dict) + 1)
                        obj_index_dict[obj_name] = line_split[6]
                    line_split[6] = obj_index_dict[obj_name]

                for x in range(len(line_split)-1):
                    f_out_id.write(line_split[x] + ' ')
                f_out_id.write(obj_name)
                f_out_id.write('\n') 
        f_out_id.close()
        f_in_id.close()

f_list_id = open('../translated_with_obj_name/obj_list.txt','w')

for i in range(len(obj_index_dict)):
    if i == 0:
        continue
    name = inverse_lookup(obj_index_dict,str(i))
    print i,name
    
    f_list_id.write(str(i) + ' : ' + name + '\n')


f_list_id.close();


print '\n\nDone.'