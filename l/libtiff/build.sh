mkdir -p libtiff-build &&
cd       libtiff-build &&

cmake -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.1.0 \
      -DCMAKE_INSTALL_PREFIX=/usr -G Ninja .. &&
ninja

DESTDIR=$P ninja install

