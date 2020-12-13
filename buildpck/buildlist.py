#!/usr/bin/env python3

import json
import os
import subprocess
import sys
from os import path
import tempfile
from subprocess import Popen, PIPE, DEVNULL

if len(sys.argv) < 2:
    print("Usage: buildlist <list_file>")
    sys.exit(1)

list_file = sys.argv[1]

f = open(list_file)
pcks = f.readlines()

for pck in pcks:
    print("Building package: ", pck)

    p = subprocess.Popen(os.path.dirname(os.path.realpath(__file__)) + "/buildpck.py " + pck, shell=True)

    if p.wait() != 0:
        print("FAILED")
        sys.exit(1)
