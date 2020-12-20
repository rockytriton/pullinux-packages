./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libsndfile-1.0.28 &&
make
make DESTDIR=$P install

