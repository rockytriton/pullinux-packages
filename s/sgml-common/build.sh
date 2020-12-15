patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch &&
autoreconf -f -i

./configure --prefix=/usr --sysconfdir=/etc &&
make

make DESTDIR=$P docdir=/usr/share/doc install &&

mkdir -p $P/_install

cat > $P/_install/install.sh << "EOF"

install-catalog --add $P/etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&

install-catalog --add $P/etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat

EOF

