mkdir build &&
cd    build &&

meson --prefix=/usr .. &&
ninja

DESTDIR=$P ninja install

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

install -vdm755 /usr/share/applications &&
update-desktop-database /usr/share/applications

EOF


