name: libva-nomesa
version: 2.10.0
repo: core
source: https://github.com/intel/libva/releases/download/2.10.0/libva-2.10.0.tar.bz2
deps: [
  'libdrm',
  'xlibs'
]
mkdeps: []
extras: [
  'https://github.com/intel/intel-vaapi-driver/releases/download/2.4.1/intel-vaapi-driver-2.4.1.tar.bz2'
]
