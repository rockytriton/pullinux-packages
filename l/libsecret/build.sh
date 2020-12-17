mkdir bld &&
cd bld &&

meson --prefix=/usr -Dgtk_doc=false .. &&
ninja

DESTDIR=$P ninja install

