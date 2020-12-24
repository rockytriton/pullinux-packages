autoreconf -fiv              &&
./configure --prefix=/usr    \
            --without-python &&
make
make DESTDIR=$P install
