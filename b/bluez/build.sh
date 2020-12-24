#KMOD
#[*] Networking support --->                [CONFIG_NET]
#  </M> Bluetooth subsystem support --->    [CONFIG_BT]
#    <*/M> RFCOMM protocol support          [CONFIG_BT_RFCOMM]
#    [*]   RFCOMM TTY support               [CONFIG_BT_RFCOMM_TTY]
#    <*/M> BNEP protocol support            [CONFIG_BT_BNEP]
#    [*]   Multicast filter support         [CONFIG_BT_BNEP_MC_FILTER]
#    [*]   Protocol filter support          [CONFIG_BT_BNEP_PROTO_FILTER]
#    <*/M> HIDP protocol support            [CONFIG_BT_HIDP]
#        Bluetooth device drivers --->
#          (Select the appropriate drivers for your Bluetooth hardware)

#  <*/M> RF switch subsystem support --->   [CONFIG_RFKILL]

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --enable-library      &&
make
make DESTDIR=$P install
mkdir $P/usr/sbin

ln -svf ../libexec/bluetooth/bluetoothd $P/usr/sbin

install -v -dm755 $P/etc/bluetooth &&
install -v -m644 src/main.conf $P/etc/bluetooth/main.conf

