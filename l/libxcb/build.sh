CFLAGS=-Wno-error=format-extra-args ./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.14 &&
make

make DESTDIR=$P install
