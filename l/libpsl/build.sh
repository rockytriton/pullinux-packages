sed -i 's/env python/&3/' src/psl-make-dafsa &&
./configure --prefix=/usr --disable-static       &&
make

make DESTDIR=$P install

