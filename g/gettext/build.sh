./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.21

make

make DESTDIR=$P install
chmod -v 0755 $P/usr/lib/preloadable_libintl.so

