./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-orbit \
            --disable-static &&
make
make DESTDIR=$P install
mkdir -p $P/etc/gconf
ln -s gconf.xml.defaults $P/etc/gconf/gconf.xml.system

