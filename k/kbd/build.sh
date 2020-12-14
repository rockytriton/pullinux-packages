patch -Np1 -i ../kbd-2.3.0-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

make DESTDIR=$P install

rm -v $P/usr/lib/libtswrap.{a,la,so*}

