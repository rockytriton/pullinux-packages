
mkdir $P/_install

cat > $P/_install/install.sh << "EOF"
groupadd -fg 27 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd

EOF

sed -i "s:/sys/fs/cgroup/systemd/:/sys:g" configure

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --with-os-type=LFS   &&
make

make DESTDIR=$P install

mkdir -p $P/etc/pam.d

cat > $P/etc/pam.d/polkit-1 << "EOF"
auth     include        system-auth
account  include        system-account
password include        system-password
session  include        system-session

EOF


