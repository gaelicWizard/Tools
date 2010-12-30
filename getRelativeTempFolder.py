#!/usr/bin/env python

import sys
from Foundation import *
import objc

myFile = sys.argv[1]

nsFileManager = NSFileManager.alloc().init()

nsItemReplacementDirectory = nsFileManager.URLForDirectory_inDomain_appropriateForURL_create_error_(NSItemReplacementDirectory, NSUserDomainMask, myFile, False, objc.NULL)
