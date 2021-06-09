name: libsoup
version: 2.72.0
repo: core
source: https://download.gnome.org/sources/libsoup/2.72/libsoup-2.72.0.tar.xz
deps: [
  'glib-networking',
  'libpsl',
  'libxml2',
  'sqlite',
  'gobject-introspection',
  'sysprof',
  'vala',
]
mkdeps: []
extras: [
  'libsoup-2.72.0-testsuite_fix-1.patch'
]
