./configure $XORG_CONFIG --with-xkb-rules-symlink=xorg &&
make
make DESTDIR=$P install

