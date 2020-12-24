./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make
mkdir -p $P/usr/lib

make DESTDIR=$P install

