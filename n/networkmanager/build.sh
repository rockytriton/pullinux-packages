sed -e 's/-qt4/-qt5/'              \
    -e 's/moc_location/host_bins/' \
    -i examples/C/qt/meson.build   &&
sed -e 's/Qt/&5/'                  \
    -i meson.build

sed '/initrd/d' -i src/meson.build

grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'

mkdir build &&
cd    build    &&

CXXFLAGS+="-O2 -fPIC"            \
meson --prefix /usr              \
      -Djson_validation=false    \
      -Dlibaudit=no              \
      -Dlibpsl=false             \
      -Dnmtui=true               \
      -Dovs=false                \
      -Dppp=false                \
      -Dselinux=false            \
      -Dqt=false                 \
      -Dudev_dir=/lib/udev       \
      -Dsession_tracking=systemd \
      -Dmodem_manager=false      \
      -Dsystemdsystemunitdir=/lib/systemd/system \
      .. &&
ninja

DESTDIR=$P ninja install &&
mv -v $P/usr/share/doc/NetworkManager{,-1.26.0}

cat >> $P/etc/NetworkManager/NetworkManager.conf << "EOF"
[main]
plugins=keyfile
EOF

cat > $P/etc/NetworkManager/conf.d/polkit.conf << "EOF"
[main]
auth-polkit=true
EOF

cat > $P/etc/NetworkManager/conf.d/dhcp.conf << "EOF"
[main]
dhcp=dhclient
EOF

cat > $P/etc/NetworkManager/conf.d/no-dns-update.conf << "EOF"
[main]
dns=none
EOF

mkdir $P/_install
cat > $P/_install/install.sh << "EOF"
groupadd -fg 86 netdev
systemctl enable NetworkManager
systemctl disable NetworkManager-wait-online

EOF

mkdir -p $P/usr/share/polkit-1/rules.d
cat > $P/usr/share/polkit-1/rules.d/org.freedesktop.NetworkManager.rules << "EOF"
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("netdev")) {
        return polkit.Result.YES;
    }
});
EOF

