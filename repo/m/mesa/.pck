name: mesa
version: 20.3.4
repo: core
source: https://mesa.freedesktop.org/archive/mesa-20.3.4.tar.xz
deps: [
  'xlibs',
  'libdrm',
  'mako',
  'libva-nomesa',
  'libvdpau',
  'llvm',
  'wayland-protocols',
]
mkdeps: []
extras: [
  'mesa-20.3.4-add_xdemos-1.patch'
]
