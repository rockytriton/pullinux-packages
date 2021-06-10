name: xorg-server
version: 1.20.10
repo: core
source: https://www.x.org/pub/individual/xserver/xorg-server-1.20.10.tar.bz2
deps: [
  'pixman',
  'font-util',
  'xkeyboard-config',
  'libepoxy',
  'wayland-protocols',
  'systemd-pam',
  'libgcrypt',
  'xcb-util-keysyms',
  'xcb-util-image',
  'xcb-util-renderutil',
  'xcb-util-wm',
]
mkdeps: []
extras: [
]
