mkdir build &&
cd build &&

meson --prefix=/usr .. &&
ninja

DESTDIR=$P ninja install

mkdir $P/_install
cat > $P/_install/install.sh << EOF

gdk-pixbuf-query-loaders --update-cache

EOF

