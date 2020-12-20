2to3-3.8 -w data/autostart/openbox-xdg-autostart
sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1 &&
make

make DESTDIR=$P install

mkdir -p $P/etc/skel/.config

cp -rf $P/etc/xdg/openbox $P/etc/skel/.config
