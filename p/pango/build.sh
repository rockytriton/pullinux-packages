mkdir build &&
cd    build &&

meson --prefix=/usr --sysconfdir=/etc .. &&
ninja

DESTDIR=$P ninja install

