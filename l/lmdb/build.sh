cd libraries/liblmdb &&
make                 &&
sed -i 's| liblmdb.a||' Makefile

make DESTDIR=$P prefix=/usr install


