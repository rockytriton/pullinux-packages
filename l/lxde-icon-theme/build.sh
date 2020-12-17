./configure --prefix=/usr
make DESTDIR=$P install

mkdir $P/_install
cat > $P/_install/install.sh << "EOF"
gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2

EOF

