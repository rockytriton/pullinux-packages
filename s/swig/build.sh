./configure --prefix=/usr \
            --without-maximum-compile-warnings &&
make
make DESTDIR=$P install
install -v -m755 -d $P/usr/share/doc/swig-4.0.2 &&
cp -v -R Doc/* $P/usr/share/doc/swig-4.0.2

