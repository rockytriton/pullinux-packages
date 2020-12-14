#!/usr/bin/env python3

import urllib.request
from tqdm import tqdm
import json
import os
import subprocess
import sys
from os import path
import tempfile
from subprocess import Popen, PIPE, DEVNULL
import shutil

base_url = "https://raw.githubusercontent.com/rockytriton/pullinux-packages/main/"
base_plx_pck = "/usr/share/pullinux"
base_packages = "/packages"

class DownloadProgressBar(tqdm):
    def update_to(self, b=1, bsize=1, tsize=None):
        if tsize is not None:
            self.total = tsize
        self.update(b * bsize - self.n)

def download_url(url, output_path):
    try:
        with DownloadProgressBar(unit='B', unit_scale=True,
                             miniters=1, desc=url.split('/')[-1]) as t:
            urllib.request.urlretrieve(url, filename=output_path + "/" + url.split('/')[-1], reporthook=t.update_to)
    except Exception as err:
        print("Fetching URL error: {0}".format(err))
        return False
    except:
        return False

    return True

def download_pck_info(pck, output_path, nobuild):

    get_json = base_url + pck[0] + "/" + pck + "/pck.json"
    get_build = base_url + pck[0] + "/" + pck + "/build.sh"

    if not download_url(get_json, output_path):
        print("Failed: " + get_json)
        return False

    if nobuild:
        return True

    if not download_url(get_build, output_path):
        print("Failed: " + get_build)
        return False

    return True

def lock():
    if path.exists(base_plx_pck + "/.lock"):
        return False

    f = open(base_plx_pck + "/.lock", "w")
    f.close()

    return True

def unlock():
    if not path.exists(base_plx_pck + "/.lock"):
        return False

    os.remove(base_plx_pck + "/.lock")

    return True

def read_json(file):
    f = open(file)
    obj = json.load(f)
    f.close()

    return obj

def get_installed_version(pck, install_path):
    pckfile = install_path + base_plx_pck + "/packages.json"

    pcks = {
        "packages":[]
    }

    if path.exists(pckfile):
        pcks = read_json(pckfile)

    for ip in pcks["packages"]:
        if (ip["name"] == pck):
            return ip["version"]
    
    return None

def add_installed_version(pck, version, install_path):
    pckfile = install_path + base_plx_pck + "/packages.json"

    pcks = {
        "packages":[]
    }

    if path.exists(pckfile):
        pcks = read_json(pckfile)

    obj = {
        "name":pck,
        "version":version
    }

    pcks["packages"].append(obj)

    f = open(pckfile, "w")
    f.write(json.dumps(pcks, indent=4))
    f.close()

def get_package(pck, version):
    tar = base_packages + "/" + pck + "-" + version + "-pullinux-1.1.1.tar.xz"

    if not path.exists(tar):
        return None

    return tar

def complete_install(pck, inst_path):
    if not path.exists(inst_path + "/_install"):
        return True

    if inst_path == "/":
        inst_script = inst_path + "/_install/install.sh"

        if path.exists(inst_script):
            p = Popen("bash -e " + inst_script, shell=True)

            if p.wait() != 0:
                print("Failed to run install script")
                shutil.rmtree("/_install")
                return False

    shutil.rmtree("/_install")
    return True

def install_deps(obj, inst_path):
    for dep in obj["deps"]:
        if get_installed_version(dep, inst_path) == None:
            print("Installing dependency: " + dep + "...")
            if not install_package(dep, inst_path):
                print("Failed to install dependency " + dep + " for " + obj["name"])
                return False
    
    return True


def install_package(pck, inst_path):
    print("Fetching package Information: " + pck + "...")
    build_path = tempfile.mkdtemp()

    if not download_pck_info(pck, build_path, True):
        print("Install Failed")
        return False

    obj = read_json(build_path + "/pck.json")
    shutil.rmtree(build_path)

    version = get_installed_version(pck, inst_path)

    if version == obj["version"]:
        print("Already installed")
        return True

    if version != None:
        print("Already installed with version: ", version)
        return False

    if not install_deps(obj):
        print("Failed to install dependencies")
        return False

    tar = get_package(pck, obj["version"])

    if tar == None:
        print("Package binaries not found")
        return False

    os.chdir(inst_path)
    p = Popen("tar -xhf " + tar, shell=True)

    if p.wait() != 0:
        print("Failed to install")
        return False

    complete_install(pck, inst_path)

    add_installed_version(pck, obj["version"], inst_path)

    p = Popen("chmod 755 " + inst_path, shell=True, stderr=DEVNULL)
    p.wait()

    print("Installation of " + pck + " " + obj["version"] + " Complete")
    return True
