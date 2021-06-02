name: glibc
version: 2.33
repo: core
source: http://ftp.gnu.org/gnu/glibc/glibc-2.33.tar.xz
deps: [
  'iana-etc',
  'linux-headers'
]
mkdeps: []
extras: [
  'glibc-2.33-fhs-1.patch',
  'https://www.iana.org/time-zones/repository/releases/tzdata2021a.tar.gz'
]
