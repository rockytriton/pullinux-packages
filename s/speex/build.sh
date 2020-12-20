./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speex-1.2.0 &&
make
make DESTDIR=$P install

