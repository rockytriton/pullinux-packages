mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"
groupadd -g 65 lightdm       &&
useradd  -c "Lightdm Daemon" \
         -d /var/lib/lightdm \
         -u 65 -g lightdm    \
         -s /bin/false lightdm

install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm      &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data &&
install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm    &&
install -v -dm770 -o lightdm -g lightdm /var/log/lightdm

install -m 644 _install/lightdm.service /lib/systemd/system
systemctl enable lightdm.service

EOF

./configure                          \
       --prefix=/usr                 \
       --libexecdir=/usr/lib/lightdm \
       --localstatedir=/var          \
       --sbindir=/usr/bin            \
       --sysconfdir=/etc             \
       --disable-static              \
       --disable-tests               \
       --with-greeter-user=lightdm   \
       --with-greeter-session=lightdm-gtk-greeter \
       --docdir=/usr/share/doc/lightdm-1.30.0 &&
make

make DESTDIR=$P install
make install

mkdir -p $P/usr/bin
cp tests/src/lightdm-session $P/usr/bin                         &&
sed -i '1 s/sh/bash --login/' $P/usr/bin/lightdm-session        &&
rm -rf $P/etc/init 

tar -xf ../lightdm-gtk-greeter-2.0.6.tar.gz &&
cd lightdm-gtk-greeter-2.0.6 &&

./configure                      \
   --prefix=/usr                 \
   --libexecdir=/usr/lib/lightdm \
   --sbindir=/usr/bin            \
   --sysconfdir=/etc             \
   --with-libxklavier            \
   --enable-kill-on-sigterm      \
   --disable-libido              \
   --disable-libindicator        \
   --disable-static              \
   --docdir=/usr/share/doc/lightdm-gtk-greeter-2.0.6 &&

make

make DESTDIR=$P install
make install

cd ..

mkdir -p $P/_install
cat > $P/_install/lightdm.service << "EOF"
[Unit]
Description=Light Display Manager
Documentation=man:lightdm(1)
Conflicts=getty@tty1.service
After=getty@tty1.service systemd-user-sessions.service plymouth-quit.service acpid.service

[Service]
ExecStart=/usr/bin/lightdm
Restart=always
IgnoreSIGPIPE=no
BusName=org.freedesktop.DisplayManager

[Install]
Alias=display-manager.service

EOF


