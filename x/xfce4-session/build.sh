./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-legacy-sm &&
make

make DESTDIR=$P install

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"
update-desktop-database &&
update-mime-database /usr/share/mime

EOF


