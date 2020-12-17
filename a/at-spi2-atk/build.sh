mkdir build &&
cd build &&

meson --prefix=/usr .. &&
ninja
DESTDIR=$P ninja install

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"
glib-compile-schemas /usr/share/glib-2.0/schemas

EOF

