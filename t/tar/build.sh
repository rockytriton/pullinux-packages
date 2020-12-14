FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin

make
make DESTDIR=$P install
make DESTDIR=$P -C doc install-html docdir=/usr/share/doc/tar-1.32
