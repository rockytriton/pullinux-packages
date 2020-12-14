./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make DESTDIR=$P MANSUFFIX=ssl install

mkdir -p $P/usr/share/doc/openssl-1.1.1g
mv -v $P/usr/share/doc/openssl $P/usr/share/doc/openssl-1.1.1g
cp -vfr doc/* $P/usr/share/doc/openssl-1.1.1g

