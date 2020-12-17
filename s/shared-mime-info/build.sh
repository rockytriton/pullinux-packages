mkdir build &&
cd    build &&

meson --prefix=/usr -Dupdate-mimedb=true .. &&
ninja

DESTDIR=$P ninja install

