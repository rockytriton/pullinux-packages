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
base_pck_cache = base_plx_pck + "/cache"
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

def store_pck_info_cache(pck, json, build):
    output_path = base_pck_cache + "/" + pck[0] + "/" + pck
    os.makedirs(output_path, exist_ok=True)

    shutil.copyfile(json, output_path + "/pck.json")

    if build == None:
        return

    shutil.copyfile(build, output_path + "/build.sh")
    

def check_pck_info_cache(pck, output_path, nobuild):
    get_json = base_pck_cache + "/" + pck[0] + "/" + pck + "/pck.json"
    get_build = base_pck_cache + "/" + pck[0] + "/" + pck + "/build.sh"

    if not path.exists(get_json):
        return False
    
    shutil.copyfile(get_json, output_path + "/pck.json")
    
    if nobuild:
        return True

    if not path.exists(get_build):
        return False
    
    shutil.copyfile(get_json, output_path + "/build.sh")

    return True
        

def show_pck_info(pck):

    get_json = base_url + pck[0] + "/" + pck + "/pck.json"
    get_build = base_url + pck[0] + "/" + pck + "/build.sh"

    if not download_url(get_json, "/tmp"):
        print("Failed: " + get_json)
        return False

    with open("/tmp/pck.json") as f:
        print(f.read())

    if not download_url(get_build, "/tmp"):
        store_pck_info_cache(pck, "/tmp" + "/pck.json", None)
        print("Failed: " + get_build)
        return False

    with open("/tmp/build.sh") as f:
        print(f.read())

    store_pck_info_cache(pck, "/tmp" + "/pck.json", "/tmp" + "/build.sh")

    return True


def download_pck_info(pck, output_path, nobuild):

    if check_pck_info_cache(pck, output_path, nobuild):
        return True

    get_json = base_url + pck[0] + "/" + pck + "/pck.json"
    get_build = base_url + pck[0] + "/" + pck + "/build.sh"

    if not download_url(get_json, output_path):
        print("Failed: " + get_json)
        return False

    if nobuild:
        store_pck_info_cache(pck, output_path + "/pck.json", None)
        return True

    if not download_url(get_build, output_path):
        print("Failed: " + get_build)
        return False

    store_pck_info_cache(pck, output_path + "/pck.json", output_path + "/build.sh")

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
        inst_script = "/_install/install.sh"

        if path.exists(inst_script):
            print("Running install script")
            p = Popen("bash -e " + inst_script, shell=True)

            if p.wait() != 0:
                print("Failed to run install script")
                shutil.rmtree("/_install")
                return False

    shutil.rmtree(inst_path + "/_install")
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

    if not install_deps(obj, inst_path):
        print("Failed to install dependencies")
        return False

    tar = get_package(pck, obj["version"])

    if tar == None:
        print("Binary not found, let's build it...")
        if not build_package(pck):
            print("Building missing package failed")
            return False

        tar = get_package(pck, obj["version"])

    if tar == None:
        print("Package binaries not found after trying to build")
        return False

    os.chdir(inst_path)
    p = Popen("tar -xhf " + tar, shell=True)

    if p.wait() != 0:
        print("Failed to install")
        return False

    if not complete_install(pck, inst_path):
        print("Failed to install")
        return False

    add_installed_version(pck, obj["version"], inst_path)

    p = Popen("chmod 755 " + inst_path, shell=True, stderr=DEVNULL)
    p.wait()

    print("Installation of " + pck + " " + obj["version"] + " Complete")
    return True

def build_package(pck):
    print("Building", pck + "...")

    build_path = tempfile.mkdtemp()

    print("Fetching package...")

    if not download_pck_info(pck, build_path, False):
        print("FAILED TO FETCH PACKAGE: " + pck)
        shutil.rmtree(build_path)
        return False

    print("Using Path:", build_path)

    inst_path = tempfile.mkdtemp()

    obj = read_json(build_path + "/pck.json")

    for dep in obj["deps"]:
        if not install_package(dep, "/"):
            print("Unable to install package, try building it first...")
            if not build_package(dep):
                print("Failed to install and build " + dep)
                return False
            
            if not install_package(dep, "/"):
                print("Built package, but failed to install it: " + dep)
                return False

    for dep in obj["mkdeps"]:
        if not install_package(dep, "/"):
            print("Unable to install package, try building it first...")
            if not build_package(dep):
                print("Failed to install and build " + dep)
                return False
            if not install_package(dep, "/"):
                print("Built package, but failed to install it: " + dep)
                return False


    os.environ["PLX_BUILD"] = build_path
    os.environ["PLX_INST"] = inst_path
    os.environ["P"] = inst_path
    os.environ["MAKEFLAGS"] = "-j8"
    os.environ["XORG_PREFIX"] = "/usr"
    os.environ["XORG_CONFIG"] = "--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"
    
    os.chdir(build_path)

    print("Changed directory into: ", build_path)

    nosource = obj["source"] == ""

    if not nosource:
        if not download_url( obj["source"], build_path):
            print("FAILED TO FETCH SOURCE: " + obj["source"])
            return False

    if "extras" in obj:
        for x in obj["extras"]:
            if not download_url(x, build_path):
                print("FAILED TO FETCH EXTRA: " + x)
                return False

    if not nosource:
        files = os.listdir()
        src = files[0]

        for ff in files:
            if obj["source"].endswith(ff):
                src = ff
                break

        if (src.endswith("zip")):
            p = Popen("unzip " + src, shell=True)
            p.wait()
        else:
            p = Popen("tar -xf " + src, shell=True)
            p.wait()

    if "nosubdir" in obj and obj["nosubdir"] == True:
        print("No sub-directory extracted, using current: " + build_path)
    else:
        files = os.listdir()

        for f in files:
            if os.path.isdir(f):
                os.chdir(f)
                break

    plx_bin = os.environ["PLX_BIN"]

    p = Popen("bash -e " + build_path + "/build.sh", universal_newlines=True, shell=True, stderr=subprocess.PIPE)
    outp, errors = p.communicate()

    if p.wait() != 0:
        print("FAILED TO INSTALL...")
        print(errors)
        print(build_path)
        print(inst_path)
        return False    

    print("Installed into " + inst_path)

    p = Popen("strip --strip-debug $P/usr/lib/*", shell=True, stderr=subprocess.DEVNULL)
    p.wait()

    p = Popen("strip --strip-unneeded $P/usr/{,s}bin/*", shell=True, stderr=subprocess.DEVNULL)
    p.wait()

    p = Popen("find $P/usr/lib -type f -name \*.a -exec strip --strip-debug {} ';'", shell=True, stderr=subprocess.DEVNULL)
    p.wait()

    p = Popen("find $P/lib $P/usr/lib -type f -name \*.so* ! -name \*dbg -exec strip --strip-unneeded {} ';'", shell=True, stderr=subprocess.DEVNULL)
    p.wait()

    p = Popen("find $P/{bin,sbin} $P/usr/{bin,sbin,libexec} -type f -exec strip --strip-all {} ';'", shell=True, stderr=subprocess.DEVNULL)
    p.wait()

    print("Packaging " + pck + "...")

    os.chdir(inst_path)
    p = Popen("tar -cJf " + plx_bin + "/" + obj["name"] + "-" + obj["version"] + "-pullinux-1.1.1.tar.xz .", shell=True)
    p.wait()

    shutil.rmtree(build_path)
    shutil.rmtree(inst_path)

    print("Build of " + pck + " " + obj["version"] + " Complete")

    return True