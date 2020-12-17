./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install

install -v -m644 -D doc/startup-notification.txt \
    $P/usr/share/doc/startup-notification-0.12/startup-notification.txt

