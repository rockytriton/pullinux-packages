PAGE=letter ./configure --prefix=/usr

make -j1

make DESTDIR=$P install

