name: nss
version: 3.61
repo: core
source: https://archive.mozilla.org/pub/security/nss/releases/NSS_3_61_RTM/src/nss-3.61.tar.gz
deps: [
  'nspr',
  'sqlite',
]
mkdeps: []
extras: [
  'nss-3.61-standalone-1.patch'
]
