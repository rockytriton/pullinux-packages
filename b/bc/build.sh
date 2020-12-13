PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3

make
make DESTDIR=$P install

