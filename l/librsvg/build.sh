./configure --prefix=/usr    \
            --enable-vala    \
            --disable-static \
            --docdir=/usr/share/doc/librsvg-2.48.8 &&
make

make DESTDIR=$P install

mkdir $P/_install
cat > $P/_install/install.sh << EOF
gdk-pixbuf-query-loaders --update-cache
EOF
