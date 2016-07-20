import os
import sys
import argparse

CR = '\x0D'  # it's \r
LF = '\x0A'  # it's \n

DIGEST_SIZE = 1024

parser = argparse.ArgumentParser(description='CRLF tool')
parser.add_argument('-f', dest='file', type=str, help='process only this file')
parser.add_argument('-d', dest='dir', type=str, help='process files in this dir')
parser.add_argument('-x', dest='check', type=str, help='only show endlines that dont match this')
args = parser.parse_args()

def discover_file(fname):
    with open(fname, 'rb') as inf:
        data = inf.read(DIGEST_SIZE)
        has_cr = (data.find(CR) != -1)
        has_lf = (data.find(LF) != -1)

        if has_cr and has_lf:
            return 'CRLF'
        elif has_cr:
            return 'CR'
        elif has_lf:
            return 'LF'

def disc_print_file(fname):
    el = discover_file(fname)
    if args.check != None:
        if el == args.check: return
    print '{0}\t{1}'.format(fname, el)

def my_filter(fname, fullname=None):
    if fname[0] == '.': return False
    basename, ext = os.path.splitext(fname)
    if ext in ['.jpg', '.jpeg', '.png', '.so', '.dyld', '.a', '.o', '.os', '.dll', '.exe', '.pyd', '.pyc']:
        return False
    return True

def discover_dir(dname):
    for root, dirs, files in os.walk(dname, topdown=True):
        exclude = [x for x in dirs if not my_filter(x)]
        for ex in exclude: dirs.remove(ex)
        for name in files:
            fullname = os.path.join(root, name)
            if not my_filter(name, fullname): continue
            disc_print_file(fullname)

if args.file:
    disc_print_file(args.file)
elif args.dir:
    discover_dir(args.dir)
