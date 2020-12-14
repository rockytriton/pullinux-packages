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

def get_installed_version(pck):
    pcks = read_json(base_plx_pck + "/pckages.json")

    for ip in pcks["packages"]:
        if (ip["name"] == pck):
            return ip["version"]
    
    return None

def get_package(pck, version):
    tar = base_packages + "/" + pck + "-" + version + "-pullinux-1.1.1.tar.xz"

    if not path.exists(tar):
        return None

    return tar
