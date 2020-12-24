./configure --prefix=/usr    \
            --with-ssl       \
            --enable-shared  \
            --disable-static &&
make
make DESTDIR=$P install
