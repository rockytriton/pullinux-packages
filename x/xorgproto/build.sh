mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX -Dlegacy=true .. &&
ninja

DESTDIR=$P ninja install &&

install -vdm 755 $P$XORG_PREFIX/share/doc/xorgproto-2020.1 &&
install -vm 644 ../[^m]*.txt ../PM_spec $P$XORG_PREFIX/share/doc/xorgproto-2020.1

