./configure --prefix=/usr --disable-static --disable-tester &&
make
make DESTDIR=$P install
