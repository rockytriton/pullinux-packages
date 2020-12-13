#!/usr/bin/env python3

import json
import os
import subprocess
import sys
from os import path
import tempfile
from subprocess import Popen, PIPE, DEVNULL
import pathlib


if len(sys.argv) < 4:
    print("Usage: makepck <name> <version> <source_url>")
    sys.exit(0)

pck = sys.argv[1]

plx_pck=os.environ["PLX_PCK"] + "/" + pck[0] + "/" + pck

pathlib.Path(plx_pck).mkdir(parents=True, exist_ok=True)

obj = {
    "name":sys.argv[1],
    "version":sys.argv[2],
    "source":sys.argv[3],
    "extras":[],
    "deps": [],
    "mkdeps":[],
    "provides":[sys.argv[1]]
}

f = open(plx_pck + "/pck.json", "w")
f.write(json.dumps(obj, indent=4))
f.close()

os.system("vim " + plx_pck + "/pck.json")

os.system("vim " + plx_pck + "/build.sh")

