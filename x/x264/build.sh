./configure --prefix=/usr \
            --enable-shared \
            --disable-cli &&
make
make DESTDIR=$P install

