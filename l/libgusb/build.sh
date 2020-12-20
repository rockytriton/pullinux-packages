mkdir build &&
cd    build &&

meson --prefix=/usr -Ddocs=false .. &&
ninja

DESTDIR=$P ninja install

