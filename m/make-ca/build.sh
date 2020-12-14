make DESTDIR=$P install
install -vdm755 $P/etc/ssl/local

/usr/sbin/make-ca -g -D $P/

