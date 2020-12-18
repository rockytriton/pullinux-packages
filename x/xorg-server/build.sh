sed -i 's/malloc(pScreen/calloc(1, pScreen/' dix/pixmap.c

./configure $XORG_CONFIG            \
            --enable-glamor         \
            --enable-suid-wrapper   \
            --with-xkb-output=/var/lib/xkb &&
make

make DESTDIR=$P install

mkdir -pv $P/etc/X11/xorg.conf.d

