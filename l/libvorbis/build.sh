./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install

mkdir -p $P/usr/share/doc/libvorbis-1.3.7
install -v -m644 doc/Vorbis* $P/usr/share/doc/libvorbis-1.3.7

