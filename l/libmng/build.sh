./configure --prefix=/usr --disable-static &&
make
make DESTDIR=$P install &&

install -v -m755 -d        $P/usr/share/doc/libmng-2.0.3 &&
install -v -m644 doc/*.txt $P/usr/share/doc/libmng-2.0.3

