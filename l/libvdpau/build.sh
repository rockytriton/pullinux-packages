mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX .. &&
ninja
DESTDIR=$P ninja install

