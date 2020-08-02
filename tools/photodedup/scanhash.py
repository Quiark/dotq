import os
import sys
import hashlib

from os.path import join


start = sys.argv[1]
logfile = open('hashes.lst', 'a')


def report(h, path):
    logfile.write('{}\t{}\n'.format(h, path))

def do_file(full):
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
