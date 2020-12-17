patch -Np1 -i ../curl-7.71.1-security_fixes-1.patch

./configure --prefix=/usr                           \
            --disable-static                        \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make

make DESTDIR=$P install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&

install -v -d -m755 $P/usr/share/doc/curl-7.71.1 &&
cp -v -R docs/*     $P/usr/share/doc/curl-7.71.1

