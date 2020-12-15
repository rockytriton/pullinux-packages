
mkdir -p $P/_install

cat > $P/_install/install.sh << "EOF"

install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd

UNITSDIR=/lib/systemd/system
CONFMODE=644

install -m ${CONFMODE} units/sshd.service ${UNITSDIR}/
install -m ${CONFMODE} units/sshdat.service ${UNITSDIR}/sshd@.service
install -m ${CONFMODE} units/sshd.socket ${UNITSDIR}/
systemctl enable sshd.service

ssh-keygen -A

EOF

mkdir $P/_install/units
cat > $P/_install/units/sshdat.service << "EOF"
[Unit]
Description=SSH Per-Connection Server

[Service]
ExecStart=/usr/sbin/sshd -i
StandardInput=socket
StandardError=syslog

EOF

cat > $P/_install/units/sshd.service << "EOF"
[Unit]
Description=OpenSSH Daemon

[Service]
ExecStart=/usr/sbin/sshd -D
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target

EOF

cat > $P/_install/units/sshd.socket << "EOF"
[Unit]
Conflicts=sshd.service

[Socket]
ListenStream=22
Accept=yes

[Install]
WantedBy=sockets.target

EOF

./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd &&
make

mkdir -p $P/usr/bin
mkdir -p $P/usr/share/man/man1

make DESTDIR=$P install
install -v -m755    contrib/ssh-copy-id $P/usr/bin     &&

install -v -m644    contrib/ssh-copy-id.1 \
                    $P/usr/share/man/man1              &&
install -v -m755 -d $P/usr/share/doc/openssh-8.3p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    $P/usr/share/doc/openssh-8.3p1

