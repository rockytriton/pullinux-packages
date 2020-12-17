autoreconf -fiv             &&
./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
make
make DESTDIR=$P install

