import os
import math

#sub-routine used for appending log msgs
def append_log(p,log):
        while 1:
                line = p.readline()
                if not line: break
                log.append(line)
        return log

def append_file(fid,lines):
        for l in lines:
                fid.write(l)

print 'Batch expand the traning data...'

info_dat_num = 10000
bg_num = 10000

os.chdir('output')

#get all sub dir 
all_subdirs = [name for name in os.listdir(".") if os.path.isdir(name)]

print all_subdirs

for subdir in all_subdirs:
        print "\nProcessing folder:",subdir
        
        if subdir == ".git" or subdir == "adl_cvpr_helper":
                print "skipping", subdir
                continue

        #######info.dat
        if os.path.isfile(subdir + '/info.dat','r'):
                print 'info.dat'
                f_in_id = open(subdir + '/info.dat','r')

                lines = []
                while True:
                        line = f_in_id.readline()

                        if len(line) == 0:break

                        lines.append(line)
        

                print 'lines:',len(lines)

                if len(lines) >= info_dat_num:
                        repeat = 0
                else:
                        repeat = math.ceil(float(info_dat_num)/float(len(lines)))
                print 'repeat:' , repeat
                
                f_in_id.close()

                f_out_id = open(subdir + '/info.dat','a')
                for x in range(int(repeat)):
                        for l in lines:
                                f_out_id.write(l)

                f_out_id.close()


        ###### bg.txt
        if os.path.isfile(subdir + '/bg.txt'):
                print 'bg.txt'
                f_in_id = open(subdir + '/bg.txt','r')

                lines = []
                while True:
                
                        line = f_in_id.readline()

                        if len(line) == 0:break

                        lines.append(line)
        

                print 'lines:',len(lines)

                if len(lines) >= info_dat_num:
                        repeat = 0
                else:
                        repeat = math.ceil(float(info_dat_num)/float(len(lines)))
                print 'repeat:' , repeat

                f_in_id.close()

                f_out_id = open(subdir + '/bg.txt','a')
                for x in range(int(repeat)):
                        for l in lines:
                                f_out_id.write(l)

                f_out_id.close()

print '\n\nDone.'
