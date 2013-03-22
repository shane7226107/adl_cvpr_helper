import os

#sub-routine used for appending log msgs
def append_log(p,log):
        while 1:
                line = p.readline()
                if not line: break
                log.append(line)
        return log

print 'Removing additional comments...\n\n'

os.chdir("action_annotation")
for files in os.listdir("."):
    if files.endswith(".txt") and not files == "action_list.txt":
        print files
        #read file
        f_in_id = open(files,'r')

        f_out_id = open('no_additional_comment/'+files+'.no_comment','w')

        while True:
                line = f_in_id.readline().replace('\n','')

                if len(line) == 0:break

                #print line
                line_split  = line.split(" ")
                
                f_out_id.write(line_split[0] + ' ' + line_split[1] + ' ' + line_split[2] + '\n')

        f_out_id.close()
        f_in_id.close()




'''
#get all sub dir 
all_subdirs = [name for name in os.listdir(".") if os.path.isdir(name)]

print all_subdirs

for subdir in all_subdirs:
        print "\nProcessing folder:",subdir
        
        if subdir == ".git" or subdir == "adl_cvpr_helper":
                print "skipping", subdir
                continue

        #read file
        f_in_id = open(subdir+"/info.dat",'r')

        f_out_id = open(subdir+"/info_x_y_width_height.txt",'w')
        
        width_list = []
        height_list = []

        while True:
                line = f_in_id.readline()

                if len(line) == 0:break

                #print line
                line_split  = line.split(" ")
                x_start = line_split[2]
                y_start = line_split[3]
                width = line_split[4]
                height = line_split[5]

                #print x_start , y_start , width , height
                tmp = x_start + ' ' + y_start + ' ' + width + ' ' + height
                f_out_id.write(tmp)

        f_out_id.close()
        f_in_id.close()
'''
print '\n\nDone.'