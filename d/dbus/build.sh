./configure --prefix=/usr                       \
            --sysconfdir=/etc                   \
            --localstatedir=/var                \
            --disable-static                    \
            --disable-doxygen-docs              \
            --disable-xml-docs                  \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console

make

make DESTDIR=$P install

mkdir -p $P/lib
mv -v $P/usr/lib/libdbus-1.so.* $P/lib
ln -sfv ../../lib/$(readlink $P/usr/lib/libdbus-1.so) $P/usr/lib/libdbus-1.so

ln -sfv /etc/machine-id $P/var/lib/dbus

sed -i 's:/var/run:/run:' $P/lib/systemd/system/dbus.socket


