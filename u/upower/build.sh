./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-deprecated  \
            --disable-static     &&
make

make DESTDIR=$P install

mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"

systemctl enable upower

EOF

#KMOD
#
#General Setup --->
#    [*] Namespaces support --->     [CONFIG_NAMESPACES]
#       [*] User namespace           [CONFIG_USER_NS]
#

