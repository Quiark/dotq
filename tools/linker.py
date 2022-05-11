#!/Users/roman/.nix-profile/bin/python
# Linker wrapper script, doesn't do anything in particular but can be useful to manipulate args if needed
import os
import sys
from functools import reduce
from pprint import pprint
import subprocess

#LD_PRG = "/nix/store/7x146iwjp51ris4gzkys7ypyvj29c7yp-aarch64-unknown-linux-gnu-binutils-2.35.2/bin/aarch64-unknown-linux-gnu-ld"
LD_PRG = '/nix/store/zcxcgngz6w0npan2bkmkx3pnjpij3gj5-aarch64-unknown-linux-gnu-binutils-2.38/bin/aarch64-unknown-linux-gnu-ld'
#GLIBC_PATH = '/nix/store/qyd4c78dl0kbpbc3lc2klp5bzy6585g7-glibc-2.33-108/lib/'
#GCCLIB_PATH = '/nix/store/4ld6q907csm7lkq4zwh0y7s5c95d1cdi-gcc-11.2.0/lib/gcc/aarch64-unknown-linux-gnu/11.2.0/'
# paths matching build on tufir.valid
#GCCLIB_PATH = "/nix/store/jpfzks4lwq521ys3nplm6yx84wim02aa-gcc-9.3.0-lib/lib/"
#GLIBC_PATH = "/nix/store/xrrm1xl7l938dyd290xy51k0iw8lc0kf-glibc-aarch64-unknown-linux-gnu-2.34-115/lib/"


# pkgsArm.gcc.libc.outPath :: macbook -- libc for arm
GLIBC_PATH = '/nix/store/byzc5grcp42871kmnr7q6alk3gx7jn12-glibc-2.34-115/lib/'
# pkgsArm.gcc.cc.lib.outPath :: macbook -- some lib for gcc for arm (?)
GCCLIB_PATH = '/nix/store/xagr8acm10zrvm44acdn849mw7s86b8x-gcc-9.3.0-lib/lib/'

# TODO try
#  - dont have crtbeginS.o
#   - on tufir.valid its under y7s6vj4xnlmjplk57qmz1yfg7f8ri2mp, find what is the corresponding expression there and use it here
#  - set gcclib to cross-compiler

CLANG_ON = False

if __name__ == '__main__':
    argv = sys.argv
    print('-'*20 + 'INPUT ARGS')
    pprint(argv)

    argopts = ['-o', '-plugin', '-dynamic-linker', '-L'] 

    # for lld
    skipopts = ['--as-needed', '--start-group' , '-Bstatic', '--end-group', '-Bdynamic', '--eh-frame-hdr',
            '-znoexecstack', '--gc-sections', '-zrelro', '-znow']

    state = 0
    openopt = None
    out_inputs = []
    out_switches = []
    out_valued = []
    out_grouped = []
    for it in argv[1:]:
        if it[0] == '-':
            if it in argopts:
                state = 1
                openopt = it
            elif it == '--start-group':
                state = 2
            elif it == '--end-group':
                state = 1
                openopt = it
            elif it in ['-Bstatic', '-Bdynamic']:
                pass #skip
            elif it[:2] == '-L':
                continue
            else:
                out_switches.append(it)
        else:
            if state == 0:
                out_inputs.append(it)
            elif state == 1:
                out_valued.append((openopt, it))
                state = 0
            elif state == 2:
                out_grouped.append(it)


    #pprint(dict(out_inputs=out_inputs, out_switches=out_switches, valued=out_valued, grouped=out_grouped))
    out_valued = list(filter(lambda x: x[0] != '-L', out_valued))
    out_valued += [('-dynamic-linker', GLIBC_PATH + 'ld-linux-aarch64.so.1')]
    out_switches += ['--build-id', '--hash-style=gnu', '-X', '-EL', '-maarch64linux', '-pie', '-v']
    if CLANG_ON:
        out_switches = list(filter(lambda x: x not in skipopts, out_switches))
        out_switches += ['-fuse-ld=lld']

    invocation = ([LD_PRG] +
            out_switches +
            [
                GLIBC_PATH + 'Scrt1.o',
                #GLIBC_PATH + 'libc_nonshared.a',
                GLIBC_PATH + 'crti.o',
                #GCCLIB_PATH + 'crtbeginS.o',
            ] +
            ['--start-group', '-Bstatic'] + out_grouped +['-Bdynamic'] +
            reduce(lambda a, b: a + [b[0], b[1]], out_valued, []) +
            out_inputs +
            ['-L', GLIBC_PATH] +
            ['-L', GCCLIB_PATH] +
            [
                #GCCLIB_PATH + 'crtendS.o',
                GLIBC_PATH + 'crtn.o'
            ]
    )
    print('='*20 + ' INVOCATION:')
    pprint(invocation)
    f_stdout = open('stdout.txt', 'wb')
    f_stderr = open('stderr.txt', 'wb')
    subprocess.check_call(invocation, shell=False, stdout=f_stdout, stderr=f_stderr)
    raise RuntimeError('just to see output')
