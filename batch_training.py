import os
import time

#sub-routine used for appending log msgs
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
        begin_time = time.localtime(time.time())
        localtime = time.asctime(begin_time)
        log.append("Begin: " + localtime + "\n")

        #recreate the classifier folder
        cmd = 'rm -r ' + subdir + '/classifier'
        p = os.popen(cmd , 'r')
        time.sleep(0.5)
        cmd = 'mkdir ' + subdir + '/classifier'
        p = os.popen(cmd , 'r')
        
        #produce sample.vec
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
        end_time = time.localtime(time.time()) 
        localtime = time.asctime(end_time)
        log.append("\nEnd: "+localtime)

        time_spend = '\ntime spend: ' + str(end_time[3] - begin_time[3]) + ' hours ' + str(end_time[4] - begin_time[4]) + ' mins ' + str(end_time[5] - begin_time[5]) + ' secs '                                 
        log.append(time_spend)


        #logging
        for line in log:
                f_out_id.write(line)

        f_out_id.close()

print '\n\nbatch_Haar training is DONE!'
