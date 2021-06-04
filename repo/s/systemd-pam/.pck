name: systemd-pam
version: 247
repo: core
source: https://github.com/systemd/systemd/archive/v247/systemd-247.tar.gz
deps: [
  'libcap-pam', 'dbus-base'
]
mkdeps: []
extras: [
  'http://www.linuxfromscratch.org/patches/blfs/10.1/systemd-247-upstream_fixes-1.patch'
]
