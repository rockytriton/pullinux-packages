sed -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' \
    -i tools/Makefile.in

./configure --prefix=/usr            \
            --enable-symcryptrun     \
            --localstatedir=/var     \
            --docdir=/usr/share/doc/gnupg-2.2.21 &&
make 

make DESTDIR=$P install

