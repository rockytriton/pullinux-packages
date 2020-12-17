./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install

tar -xf ../libcdio-paranoia-10.2+2.0.1.tar.bz2 &&
cd libcdio-paranoia-10.2+2.0.1 &&

./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install

