patch -Np1 -i ../menu-cache-1.1.0-consolidated_fixes-1.patch

./configure --prefix=/usr    \
            --disable-static &&
make

make DESTDIR=$P install

