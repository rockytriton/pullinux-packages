mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make

make DESTDIR=$P install

mkdir -p $P/usr/share/applications/
mv -v $P$KF5_PREFIX/share/kde4/services/khelpcenter.desktop $P/usr/share/applications/ &&
rm -rv $P$KF5_PREFIX/share/kde4

