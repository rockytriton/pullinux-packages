./configure --prefix=/usr --disable-static

make

make DESTDIR=$P docdir=/usr/share/doc/check-0.15.2 install

