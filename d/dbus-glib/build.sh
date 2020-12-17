./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static &&
make

make DESTDIR=$P install

