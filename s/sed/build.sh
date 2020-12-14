./configure --prefix=/usr --bindir=/bin

make
make html

make DESTDIR=$P install
install -d -m755           $P/usr/share/doc/sed-4.8
install -m644 doc/sed.html $P/usr/share/doc/sed-4.8

