LIBS=-lm                      \
./configure --prefix=/usr     \
            --without-doxygen \
            --docdir=/usr/share/doc/gavl-1.4.0 &&
make
make DESTDIR=$P install

