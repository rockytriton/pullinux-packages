./configure --prefix=/usr --disable-oss &&
make

make DESTDIR=$P docdir=/usr/share/doc/libcanberra-0.30 install
