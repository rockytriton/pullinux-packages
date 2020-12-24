make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes

make DESTDIR=$P PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&

chmod -v 755 $P/usr/lib/libpci.so

