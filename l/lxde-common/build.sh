./configure --prefix=/usr --sysconfdir=/etc &&
make
make DESTDIR=$P install

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

update-mime-database /usr/share/mime &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
update-desktop-database -q

EOF

mkdir -p $P/etc/skel
cat > $P/etc/skel/.xinitrc << "EOF"
# No need to run dbus-launch, since it is run by startlxde
startlxde
EOF

