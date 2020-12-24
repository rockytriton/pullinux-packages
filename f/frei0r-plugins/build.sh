mkdir -vp build &&
cd        build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DWITHOUT_OPENCV=TRUE       \
      -Wno-dev ..                 &&

make
make DESTDIR=$P install

