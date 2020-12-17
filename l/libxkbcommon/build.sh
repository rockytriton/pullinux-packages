mkdir build &&
cd    build &&

meson --prefix=/usr -Denable-docs=false .. &&
ninja
DESTDIR=$P ninja install

