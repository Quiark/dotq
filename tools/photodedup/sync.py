import os
import sys
import time
import shutil
import subprocess
from os.path import join


SRCLIST = 'mac.lst'
SRC = '/Users/roman/Pictures/Photos Library.photoslibrary/'

DSTLIST = 'nas.lst'
DST = '/Volumes/Katrina/Photos Library.photoslibrary/'


def read_list(fname):
    result = {}
    with open(fname) as inf:
        for line in inf:
            parts = line.split('\t')
            result[parts[0]] = parts[1].strip()

    return result

mintime = None
maxtime = None

def copy(fname):
    global mintime, maxtime
    srcfull = join(SRC, fname)
    dstfull = join(DST, fname)
    mtime = os.path.getmtime(srcfull)
    if fname.lower().endswith('.aae'): return
    if (mintime == None) or (mtime < mintime): mintime = mtime
    if (maxtime == None) or (mtime > maxtime): maxtime = mtime

    #subprocess.call(['rsync', srcfull, dstfull], shell=False)

    st = os.stat(srcfull)
    dt = os.stat(dstfull) if os.path.exists(dstfull) else None

    if (dt == None) or (dt.st_size != st.st_size):
        basedir, _ = os.path.split(dstfull)
        if not os.path.exists(basedir): os.makedirs(basedir)
        shutil.copy(srcfull, dstfull)
        print(srcfull)
    sys.stdout.write('.')

    #print(time.ctime(mtime))
    #print('cp {} {}'.format(srcfull, dstfull))

def cmp_and_copy():
    src = read_list(SRCLIST)
    dst = read_list(DSTLIST)

    counter = 0

    for i in src:
        counter += 1
        if not (i in dst):
            copy(src[i])
        elif False:
            print('have ')
            f1 = (join(SRC, src[i]))
            f2 = (join('/Users/roman/Tasks/photodedup/zde', dst[i]))
            print(f1)
            print(f2)
            if (counter % 1000) == 0:
                os.system("open '{}'".format(f1))
                os.system("open '{}'".format(f2))

cmp_and_copy()

print('stats --')
print(time.ctime(mintime))
print(time.ctime(maxtime))
