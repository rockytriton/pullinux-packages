./configure --prefix=/usr    \
            --disable-static \
            --disable-documentation &&
make
make DESTDIR=$P install

