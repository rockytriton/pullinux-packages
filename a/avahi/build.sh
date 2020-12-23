
mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

groupadd -fg 84 avahi &&
useradd -c "Avahi Daemon Owner" -d /var/run/avahi-daemon -u 84 \
        -g avahi -s /bin/false avahi
groupadd -fg 86 netdev
systemctl enable avahi-daemon
systemctl enable avahi-dnsconfd

EOF

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --disable-libevent   \
            --disable-mono       \
            --disable-monodoc    \
            --disable-python     \
            --disable-qt3        \
            --disable-qt4        \
            --enable-core-docs   \
            --with-distro=none   \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make

make DESTDIR=$P install


