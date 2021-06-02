name: systemd-base
version: 247
repo: core
source: https://github.com/systemd/systemd/archive/v247/systemd-247.tar.gz
deps: [
  'texinfo',
]
mkdeps: []
extras: [
  'systemd-247-upstream_fixes-1.patch', 'http://anduin.linuxfromscratch.org/LFS/systemd-man-pages-247.tar.xz'
]
