sed -i '/stat.h/a #include <sys/sysmacros.h>' growisofs.c &&
sed -i '/stdlib/a #include <limits.h>' transport.hxx &&
make all rpl8 btcflash
make DESTDIR=$P prefix=/usr install &&
install -v -m644 -D index.html \
    $P/usr/share/doc/dvd+rw-tools-7.1/index.html

