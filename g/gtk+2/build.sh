sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
    -i docs/{faq,tutorial}/Makefile.in      &&

./configure --prefix=/usr --sysconfdir=/etc &&

make
make DESTDIR=$P install

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"
gtk-query-immodules-2.0 --update-cache

EOF

mkdir -p $P/etc/skel
cat > $P/etc/skel/.gtkrc-2.0 << "EOF"
include "/usr/share/themes/Glider/gtk-2.0/gtkrc"
gtk-icon-theme-name = "hicolor"
EOF

mkdir -p $P/etc/gtk-2.0

cat > $P/etc/gtk-2.0/gtkrc << "EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "elementary"
EOF


