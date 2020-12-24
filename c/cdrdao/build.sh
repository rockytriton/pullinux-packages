./configure --prefix=/usr --mandir=/usr/share/man &&
make
make DESTDIR=$P install &&
install -v -m755 -d $P/usr/share/doc/cdrdao-1.2.4 &&
install -v -m644 README $P/usr/share/doc/cdrdao-1.2.4

