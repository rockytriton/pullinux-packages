./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/Thunar-1.8.15 &&
make

make DESTDIR=$P install

