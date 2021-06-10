name: poppler
version: 21.02.0
repo: core
source: https://poppler.freedesktop.org/poppler-21.02.0.tar.xz
deps: [
  'fontconfig',
  'cairo',
  'lcms2',
  'libjpeg-turbo',
  'libpng',
  'nss',
  'openjpeg',
]
mkdeps: [
  'cmake'
]
extras: [
  'https://poppler.freedesktop.org/poppler-data-0.4.10.tar.gz'
]
