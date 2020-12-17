./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --enable-user-session                \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --disable-static                     \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console \
            --with-system-pid-file=/run/dbus/pid \
            --with-system-socket=/run/dbus/system_bus_socket &&
make
make DESTDIR=$P install

mkdir -p $P/lib
mv -v $P/usr/lib/libdbus-1.so.* $P/lib &&
ln -sfv ../../lib/$(readlink $P/usr/lib/libdbus-1.so) $P/usr/lib/libdbus-1.so

chown -v root:messagebus $P/usr/libexec/dbus-daemon-launch-helper &&
chmod -v      4750       $P/usr/libexec/dbus-daemon-launch-helper

mkdir -p $P/etc/dbus-1

cat > $P/etc/dbus-1/session-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>

  <!-- Search for .service files in /usr/local -->
  <servicedir>/usr/local/share/dbus-1/services</servicedir>

</busconfig>
EOF


