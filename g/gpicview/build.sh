./configure --prefix=/usr &&
make

make DESTDIR=$P install

sed -i 's/Utility;//' $P/usr/share/applications/gpicview.desktop

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

xdg-icon-resource forceupdate --theme hicolor

EOF

