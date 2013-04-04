import os

#sub-routine used for appending log msgs
def append_log(p,log):
        while 1:
                line = p.readline()
                if not line: break
                log.append(line)
        return log

print 'Batch copy...'

#get all sub dir 
all_subdirs = [name for name in os.listdir(".") if os.path.isdir(name)]

print all_subdirs

for subdir in all_subdirs:
        print "\nProcessing folder:",subdir
        
        if subdir == ".git" or subdir == "adl_cvpr_helper":
                print "skipping", subdir
                continue

        if os.path.isfile(subdir + "/classifier"):

                os.chdir(subdir + "/classifier")
        
                print "cp " + "cascade.xml " + "~/Desktop/cascade/" + subdir + ".xml"
                os.system("cp " + "cascade.xml " + "~/Desktop/cascade/" + subdir + ".xml")

                os.chdir("../..")
        else:
                print subdir, "is not successfully trianed!"


print '\n\nBatch copy is done.'
