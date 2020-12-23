./configure --prefix=/usr --disable-static &&
make
make DESTDIR=$P docdir=/usr/share/doc/libdaemon-0.14 install

