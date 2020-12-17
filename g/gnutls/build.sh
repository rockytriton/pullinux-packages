./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.6.14 \
            --disable-guile \
            --with-default-trust-store-pkcs11="pkcs11:" &&
make

make DESTDIR=$P install

