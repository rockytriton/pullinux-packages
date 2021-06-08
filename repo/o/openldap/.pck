name: openldap
version: 2.4.57
repo: core
source: https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.57.tgz
deps: [
  'cyrus-sasl',
  'gnutls',
]
mkdeps: []
extras: [
  'openldap-2.4.57-consolidated-1.patch'
]
