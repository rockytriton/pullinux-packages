./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.9

make

make DESTDIR=$P install

install -dv -m644 doc/*.{html,png,css} $P/usr/share/doc/expat-2.2.9

