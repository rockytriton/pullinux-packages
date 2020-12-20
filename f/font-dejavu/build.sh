install -v -d -m755 $P/usr/share/fonts/dejavu &&
install -v -m644 ttf/*.ttf $P/usr/share/fonts/dejavu

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

fc-cache -v /usr/share/fonts/dejavu

EOF

