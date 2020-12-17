mkdir build &&
cd    build &&

meson --prefix=/usr -Dbuildtype=release .. &&
ninja

DESTDIR=$P ninja install

