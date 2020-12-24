./configure --prefix=/usr --disable-static &&
make
make DESTDIR=$P htmldocdir=/usr/share/doc/libsamplerate-0.1.9 install

