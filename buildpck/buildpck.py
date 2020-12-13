#!/usr/bin/env python3

import json
import os
import subprocess
import sys
from os import path
import tempfile
from subprocess import Popen, PIPE, DEVNULL

if len(sys.argv) < 2:
    print("Usage: buildpck <package_name>")
    sys.exit(1)

pck = sys.argv[1]

print("Building", pck + "...")

plx_pck=os.environ["PLX_PCK"] + "/" + pck[0] + "/" + pck

if not path.exists(plx_pck):
    print("Invalid package:", pck)
    sys.exit(2)

print("Using Path:", plx_pck)

build_path = tempfile.mkdtemp()
inst_path = tempfile.mkdtemp()

os.environ["PLX_BUILD"] = build_path
os.environ["PLX_INST"] = inst_path
os.environ["P"] = inst_path
os.environ["MAKEFLAGS"] = "-j8"

obj = json.load(open(plx_pck + "/pck.json"))

print("Fetching sources...")

os.chdir(build_path)

print("Changed directory into: ", build_path)

p = subprocess.Popen("wget " + obj["source"], shell=True)
p.wait()

if "extras" in obj:
    for x in obj["extras"]:
        p = subprocess.Popen("wget " + x, shell=True)
        p.wait()

files = os.listdir()

if len(files) == 0:
    printf("Unable to download source")
    sys.exit(3)

tarf = files[0]

p = Popen("tar -xf " + tarf, shell=True)
p.wait()

files = os.listdir()

for f in files:
    if f == tarf:
        continue
    os.chdir(f)
    break

plx_bin = os.environ["PLX_BIN"]

p = Popen("bash -e " + plx_pck + "/build.sh", shell=True, stderr=subprocess.PIPE)
outp, errors = p.communicate()

if p.wait() != 0:
    print("FAILED TO INSTALL...")
    print(errors)
    f = open(plx_bin + "/" + obj["name"] + "-errors.txt", "w")
    f.write(errors)
    f.close()
    sys.exit(1)    

print("Installed into " + inst_path)

os.chdir(inst_path)
p = Popen("tar -cJf " + plx_bin + "/" + obj["name"] + "-" + obj["version"] + "-pullinux-1.1.1.tar.xz .", shell=True)
p.wait()

print("")
print("DONE")
print("")
