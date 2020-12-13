expect -c "spawn ls"

sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

make tooldir=/usr

make DESTDIR=$P tooldir=/usr install

