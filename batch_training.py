import os

print 'batch_Haar training...'

#get all sub dir 
all_subdirs = [name for name in os.listdir(".") if os.path.isdir(name)]

print all_subdirs

for subdir in all_subdirs:
        #print subdir
        f_out_id = open(subdir+'/log.txt','w')
        
        #recreate the classifier folder
        cmd = 'rm -r ' + subdir + '/classifier'
        p = os.popen(cmd , 'r')
        cmd = 'mkdir ' + subdir + '/classifier'
        p = os.popen(cmd , 'r')
        
        #p = os.popen('pwd','r')
        cmd = 'opencv_createsamples -info ' + subdir + '/info.dat -vec ' + subdir + '/samples.vec -bg ' + subdir +'/bg.txt -w 24 -h 24 -num 7000'

        print cmd
        p = os.popen(cmd , 'r')

        response_lines = []

        while 1:
                line = p.readline()
                if not line: break
                response_lines.append(line)
                f_out_id.write(line)
        
        print response_lines
        f_out_id.close()

print '\n\nbatch_Haar training is DONE!'
