mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make DESTDIR=$P install

