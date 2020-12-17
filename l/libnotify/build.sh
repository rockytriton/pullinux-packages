mkdir build &&
cd    build &&

meson --prefix=/usr -Dgtk_doc=false -Dman=false .. &&
ninja

DESTDIR=$P ninja install

