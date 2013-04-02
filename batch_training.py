import os
import time
import datetime

#sub-routine used for appending log msgs with muti-lines
def append_log(p,log):
        while 1:
                line = p.readline()
                if not line: break
                log.append(line)
        return log

print 'batch_Haar training...'

#get all sub dir 
all_subdirs = [name for name in os.listdir(".") if os.path.isdir(name)]

print all_subdirs

for subdir in all_subdirs:
        print "\nProcessing folder:",subdir
        
        #subdir
        f_out_id = open(subdir+'/log.txt','w')
        
        #log msgs
        log = []

        #begin time
        begin_time = time.time()
        localtime = time.asctime(time.localtime(begin_time))
        log.append("Begin: " + localtime + "\n")

        #recreate the classifier folder
        cmd = 'rm -r ' + subdir + '/classifier'
        p = os.popen(cmd , 'r')
        time.sleep(0.5)
        cmd = 'mkdir ' + subdir + '/classifier'
        p = os.popen(cmd , 'r')
        
        #produce sample.vec
        if os.path.isfile(subdir + '/info.dat'):
                log.append('\n===produce sample.vec===\n') 
                cmd = 'opencv_createsamples -info ' + subdir + '/info.dat -vec ' + subdir + '/samples.vec -bg ' + subdir +'/bg.txt -w 24 -h 24 -num 7000'
                p = os.popen(cmd , 'r')
                log = append_log(p,log)
        
                #training
                log.append('\n===training===\n') 
                cmd = 'opencv_traincascade -data '+ subdir + '/classifier -vec ' + subdir + '/samples.vec -bg ' + subdir + '/bg.txt -featureType LBP -precalcValBufSize 512 -precalcIdxBufSize 512'
                p = os.popen(cmd , 'r')
                log = append_log(p,log)
        
                #end time
                end_time = time.time()
                localtime = time.asctime(time.localtime(begin_time))
                log.append("End: "+localtime)
        
                #time spent
                time_spent = str(datetime.timedelta(seconds= (end_time-begin_time )))
                print time_spent
                log.append("\n\n\ntime spent: "+ time_spent)
        else:
                log.append("No info.dat found for" + subdir)
                
        #logging
        for line in log:
                f_out_id.write(line)

        f_out_id.close()

print '\n\nbatch_Haar training is DONE!'
