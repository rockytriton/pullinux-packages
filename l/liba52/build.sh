./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --enable-shared \
            --disable-static \
            CFLAGS="-g -O2 $([ $(uname -m) = x86_64 ] && echo -fPIC)" &&
make
make DESTDIR=$P install
mkdir -p $P/usr/include/a52dec

cp liba52/a52_internal.h $P/usr/include/a52dec

install -v -m644 -D doc/liba52.txt \
    $P/usr/share/doc/liba52-0.7.4/liba52.txt

