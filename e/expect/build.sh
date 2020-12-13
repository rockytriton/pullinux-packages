./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make

sudo make DESTDIR=$PLX_INST install

ln -svf expect5.45.4/libexpect5.45.4.so $PLX_INST/usr/lib

