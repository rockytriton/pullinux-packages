./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-dbus     &&
make
make DESTDIR=$P install

