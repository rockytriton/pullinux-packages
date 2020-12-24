./configure --prefix=/usr     \
            --enable-gpl      \
            --enable-gpl3     \
            --enable-opengl   \
            --disable-gtk2    &&
make
make DESTDIR=$P install

