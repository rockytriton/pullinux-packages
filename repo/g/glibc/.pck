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
  'https://github.com/rockytriton/pullinux-packages/releases/download/1.2.0.2/tzdata2021a.tar.gz'
]
