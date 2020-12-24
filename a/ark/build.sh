patch -Np1 -i ../ark-20.08.0-upstream_fix-1.patch
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make

make DESTDIR=$P install

