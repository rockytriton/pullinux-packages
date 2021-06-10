name: bluez
version: 5.55
repo: core
source: https://www.kernel.org/pub/linux/bluetooth/bluez-5.55.tar.xz
deps: [
  'dbus-pam',
  'glib',
  'libical',
]
mkdeps: []
extras: [
  'http://www.linuxfromscratch.org/patches/blfs/10.1/bluez-5.55-upstream_fixes-1.patch'
]
