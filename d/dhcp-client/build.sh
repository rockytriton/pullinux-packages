sed -i '/o.*dhcp_type/d' server/mdb.c &&
sed -r '/u.*(local|remote)_port/d'    \
    -i client/dhclient.c              \
       relay/dhcrelay.c

( export CFLAGS="$CFLAGS -Wall -fno-strict-aliasing                 \
        -D_PATH_DHCLIENT_SCRIPT='\"/sbin/dhclient-script\"'         \
        -D_PATH_DHCPD_CONF='\"/etc/dhcp/dhcpd.conf\"'               \
        -D_PATH_DHCLIENT_CONF='\"/etc/dhcp/dhclient.conf\"'"        &&

./configure --prefix=/usr                                           \
            --sysconfdir=/etc/dhcp                                  \
            --localstatedir=/var                                    \
            --with-srv-lease-file=/var/lib/dhcpd/dhcpd.leases       \
            --with-srv6-lease-file=/var/lib/dhcpd/dhcpd6.leases     \
            --with-cli-lease-file=/var/lib/dhclient/dhclient.leases \
            --with-cli6-lease-file=/var/lib/dhclient/dhclient6.leases
) &&
make -j1

mkdir -p $P/sbin
make DESTDIR=$P -C client install         &&
mv -v $P/usr/sbin/dhclient $P/sbin &&
install -v -m755 client/scripts/linux $P/sbin/dhclient-script

mkdir -p $P/etc
install -vdm755 $P/etc/dhcp &&
cat > $P/etc/dhcp/dhclient.conf << "EOF"
#prepend domain-name-servers 127.0.0.1;
request subnet-mask, broadcast-address, time-offset, routers,
        domain-name, domain-name-servers, domain-search, host-name,
        netbios-name-servers, netbios-scope, interface-mtu,
        ntp-servers;
require subnet-mask, domain-name-servers;
#timeout 60;
#retry 60;
#reboot 10;
#select-timeout 5;
#initial-interval 2;

EOF

install -v -dm 755 $P/var/lib/dhclient

