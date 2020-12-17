mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=RELEASE  \
      -DENABLE_STATIC=FALSE       \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-2.0.5 \
      -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib  \
      .. &&
make

make DESTDIR=$P install

