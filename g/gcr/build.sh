sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml &&

sed -i '610 s/;/ = { 0 };/' gck/gck-slot.c &&

mkdir gcr-build &&
cd    gcr-build &&

meson --prefix=/usr -Dgtk_doc=false .. &&
ninja
DESTDIR=$P ninja install

