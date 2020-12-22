mkdir bld &&
cd    bld &&

cmake -DCMAKE_INSTALL_PREFIX=/usr ../source &&
make

make DESTDIR=$P install &&
rm -vf $P/usr/lib/libx265.a

