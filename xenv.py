#!/usr/bin/env python

## from http://hints.macworld.com/article.php?story=2003121708324421

import sys
import os
from shutil import copymode
from plistlib import Plist

def main(*args):
    path = os.path.join(os.getenv("HOME"), ".MacOSX/environment.plist")
    if os.path.isfile(path):
        environ = Plist.fromFile(path)
    else:
        environ = Plist()
    for arg in args:
        try: k, v = arg.split('=',1)
        except ValueError: pass
        else: environ[k] = v
    if not args:
        for k,v in environ.items():
            print "%s=\"%s\"; export %s" % (k, v, k)
    else:
        tmppath = path
        tmppath += ".tmp"
        f = open(tmppath, "w")
        environ.write(f)
        f.close()
        copymode(path, tmppath)
        os.rename(tmppath, path)

if __name__ == "__main__":
    main(*sys.argv[1:])

