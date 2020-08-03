import os
import sys
import hashlib

from os.path import join

start = sys.argv[1]
logpath = 'hashes.lst'

def read_list(fname):
    result = {}
    if not os.path.exists(fname): return {}

    with open(fname) as inf:
        for line in inf:
            parts = line.split('\t')
            result[parts[0]] = parts[1].strip()

    return result

existing = read_list(logpath)
existing_fnames = (existing.values())
logfile = open(logpath + '.2', 'a')

def report(h, path):
    logfile.write('{}\t{}\n'.format(h, path))

def do_file(full):
    if full in existing_fnames: return

    with open(full, 'rb') as inf:
        h = hashlib.sha1()
        while True:
            data = inf.read(8192)
            if not data: break
            h.update(data)

        report(h.hexdigest(), full)


for root, dirs, files in os.walk(start):
    for name in files:
        full = join(root, name)
        do_file(full)

logfile.flush()
logfile.close()
