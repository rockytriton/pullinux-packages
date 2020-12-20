
mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"
useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp
groupadd -g 19 lpadmin

gtk-update-icon-cache -qtf /usr/share/icons/hicolor

EOF

sed -i '/stat.h/a #include <asm-generic/ioctls.h>' tools/ipptool.c   &&

CC=gcc CXX=g++ \
./configure --libdir=/usr/lib            \
            --with-rcdir=/tmp/cupsinit   \
            --with-system-groups=lpadmin \
            --with-docdir=/usr/share/cups/doc-2.3.3 &&
make
make DESTDIR=$P install &&
rm -rf /tmp/cupsinit
rm -rf $P/tmp/cupsinit

mkdir -p $P/etc/cups
echo "ServerName /run/cups/cups.sock" > /etc/cups/client.conf

mkdir -p $P/usr/share/doc

ln -svnf ../cups/doc-2.3.3 $P/usr/share/doc/cups-2.3.3

mkdir -p $P/etc/pam.d

cat > $P/etc/pam.d/cups << "EOF"
# Begin /etc/pam.d/cups

auth    include system-auth
account include system-account
session include system-session

# End /etc/pam.d/cups
EOF

