#KMOD
#[*] Networking support  --->                                          [CONFIG_NET]
#      Networking Options  --->
#        [*] Network packet filtering framework (Netfilter) --->       [CONFIG_NETFILTER]
#          [*] Advanced netfilter configuration                        [CONFIG_NETFILTER_ADVANCED]
#          Core Netfilter Configuration --->
#            <*/M> Netfilter connection tracking support               [CONFIG_NF_CONNTRACK]
#            <*/M> Netfilter Xtables support (required for ip_tables)  [CONFIG_NETFILTER_XTABLES]
#            <*/M> LOG target support                                  [CONFIG_NETFILTER_XT_TARGET_LOG]
#          IP: Netfilter Configuration --->
#            <*/M> IP tables support (required for filtering/masq/NAT) [CONFIG_IP_NF_IPTABLES]

./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables &&
make

make DESTDIR=$P install
mkdir -p $P/usr/bin
mkdir -p $P/lib
mkdir -p $P/usr/lib

ln -sfv ../../sbin/xtables-legacy-multi $P/usr/bin/iptables-xml &&

for file in ip4tc ip6tc ipq xtables
do
  mv -v $P/usr/lib/lib${file}.so.* $P/lib &&
  ln -sfv ../../lib/$(readlink $P/usr/lib/lib${file}.so) $P/usr/lib/lib${file}.so
done


