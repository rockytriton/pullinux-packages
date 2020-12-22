./configure --prefix=/usr --enable-mp3rtp --disable-static &&
make
make DESTDIR=$P pkghtmldir=/usr/share/doc/lame-3.100 install

