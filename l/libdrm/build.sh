mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX -Dudev=true &&
ninja

DESTDIR=$P ninja install

