patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean
make

mkdir -p $P/lib
mkdir -p $P/bin
mkdir -p $P/usr/bin
mkdir -p $P/usr/lib

make DESTDIR=$P PREFIX=/usr install

cp -v bzip2-shared $P/bin/bzip2
cp -av libbz2.so* $P/lib
ln -sv ../../lib/libbz2.so.1.0 $P/usr/lib/libbz2.so
rm -v $P/usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 $P/bin/bunzip2
ln -sv bzip2 $P/bin/bzcat

