sed -i 's@cert.pem@certs/ca-bundle.crt@' CMakeLists.txt

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$QT5DIR            \
      -DCMAKE_BUILD_TYPE=Release                \
      -DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man \
      .. &&
make

make DESTDIR=$P install

