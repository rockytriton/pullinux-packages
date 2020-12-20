mkdir build                         &&
cd    build                         &&

cmake  -DCMAKE_BUILD_TYPE=Release   \
       -DCMAKE_INSTALL_PREFIX=/usr  \
       -DTESTDATADIR=$PWD/testfiles \
       -DENABLE_UNSTABLE_API_ABI_HEADERS=ON     \
       ..                           &&
make
make DESTDIR=$P install
make install

tar -xf ../../poppler-data-0.4.9.tar.gz &&
cd poppler-data-0.4.9
make DESTDIR=$P prefix=/usr install
