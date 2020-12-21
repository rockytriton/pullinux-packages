patch -Np1 -i ../cdparanoia-III-10.2-gcc_fixes-1.patch &&
patch -Np1 -i ../0001-Use-DESTDIR-in-install-Makefile-rule.patch

./configure --prefix=/usr --mandir=/usr/share/man &&
make -j1

make DESTDIR=$P install &&
chmod -v 755 $P/usr/lib/libcdda_*.so.0.10.2

