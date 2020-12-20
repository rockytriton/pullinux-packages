make -f unix/Makefile generic_gcc

make DESTDIR=$P prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install

