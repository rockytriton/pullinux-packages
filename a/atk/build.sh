mkdir build &&
cd    build &&

meson --prefix=/usr .. &&
ninja

DESTDIR=$P ninja
