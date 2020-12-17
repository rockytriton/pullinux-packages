./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install

chmod   -v   755 $P/usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d $P/usr/share/doc/nettle-3.6 &&
install -v -m644 nettle.html $P/usr/share/doc/nettle-3.6

