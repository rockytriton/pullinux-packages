./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-bluez5     \
            --disable-rpath      &&
make
make DESTDIR=$P install

rm -fv $P/etc/dbus-1/system.d/pulseaudio-system.conf

