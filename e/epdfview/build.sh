patch -Np1 -i ../epdfview-0.1.8-fixes-2.patch &&
./configure --prefix=/usr &&
make
make DESTDIR=$P install

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

for size in 24 32 48; do
  ln -svf ../../../../epdfview/pixmaps/icon_epdfview-$size.png \
          /usr/share/icons/hicolor/${size}x${size}/apps
done &&
unset size

update-desktop-database &&
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor

EOF

