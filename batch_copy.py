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

        os.chdir(subdir + "/classifier")

        print "cp " + "cascade.xml " + "~/Desktop/cascade/" + subdir + ".xml"
        os.system("cp " + "cascade.xml " + "~/Desktop/cascade/" + subdir + ".xml")

        os.chdir("../..")
'''
        #flag
        find_cascade_file = False

        os.chdir(subdir + "/classifier")

        for files in os.listdir("."):
                if files == "cascade.xml":
                        print "find",files
                        find_cascade_file = True
                        break

        os.chdir("../..")

        if not find_cascade_file:
                print subdir, "is not successful trianed!"
'''

print '\n\nBatch copy is done.'