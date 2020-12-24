./configure --prefix=/usr --disable-static &&
make
make DESTDIR=$P docdir=/usr/share/doc/libatasmart-0.19 install

