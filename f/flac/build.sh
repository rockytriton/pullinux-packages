./configure --prefix=/usr \
            --disable-thorough-tests \
            --docdir=/usr/share/doc/flac-1.3.3 &&
make
make DESTDIR=$P install

