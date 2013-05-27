import os
import math

info_dat_num = 10000
bg_dat_num = 10000

#Positive
os.chdir("cascade")
for file_name in os.listdir("."):
    if file_name.endswith(".info"):
        print file_name

        f_in_id = open(file_name,'r')
        lines = []
        while True:
                line = f_in_id.readline()

                if len(line) == 0:break

                lines.append(line)
        f_in_id.close()
        
        print 'lines:',len(lines)


        if len(lines) >= info_dat_num:
                repeat = 0
        else:
                repeat = math.ceil(float(info_dat_num)/float(len(lines)))
        print 'repeat:' , repeat                
        

        f_out_id = open('expand/' + file_name, 'w')
        for x in range(int(repeat)):
                for l in lines:
                        f_out_id.write(l)
        f_out_id.close()
os.chdir("..")


#background
os.chdir("cascade")
for file_name in os.listdir("."):
    if file_name.endswith(".bg"):
        print file_name

        f_in_id = open(file_name,'r')
        lines = []
        while True:
                line = f_in_id.readline()

                if len(line) == 0:break

                lines.append(line)
        f_in_id.close()
        
        print 'lines:',len(lines)


        if len(lines) >= bg_dat_num:
                repeat = 0
        else:
                repeat = math.ceil(float(bg_dat_num)/float(len(lines)))
        print 'repeat:' , repeat                
        

        f_out_id = open('expand/' + file_name, 'w')
        for x in range(int(repeat)):
                for l in lines:
                        f_out_id.write(l)
        f_out_id.close()
os.chdir("..")

print '\n\nDone.'
