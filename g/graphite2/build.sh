sed -i '/cmptest/d' tests/CMakeLists.txt

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make

make DESTDIR=$P install

