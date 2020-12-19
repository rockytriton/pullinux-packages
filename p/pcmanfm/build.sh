./configure --prefix=/usr     \
            --sysconfdir=/etc &&
make
make DESTDIR=$P install

