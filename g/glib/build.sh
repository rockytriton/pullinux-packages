patch -Np1 -i ../glib-2.64.4-skip_warnings-1.patch

mkdir build &&
cd    build &&

meson --prefix=/usr      \
      -Dman=true         \
      -Dselinux=disabled \
      ..                 &&
ninja

DESTDIR=$P ninja install

mkdir -p $P/usr/share/doc/glib-2.64.4 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} $P/usr/share/doc/glib-2.64.4


