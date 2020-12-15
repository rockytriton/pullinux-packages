patch -Np1 -i ../unzip-6.0-consolidated_fixes-1.patch

make -f unix/Makefile generic

make DESTDIR=$P prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install

