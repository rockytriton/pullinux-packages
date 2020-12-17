mkdir build &&
cd    build &&

meson --prefix=/usr          \
      -Dlibproxy=disabled .. &&
ninja

DESTDIR=$P ninja install

