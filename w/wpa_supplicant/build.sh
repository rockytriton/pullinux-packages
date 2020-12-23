#KMOD
#[*] Networking support  --->                              [CONFIG_NET]
#  [*] Wireless  --->                                      [CONFIG_WIRELESS]
#    <*/M> cfg80211 - wireless configuration API           [CONFIG_CFG80211]
#    [*]     cfg80211 wireless extensions compatibility    [CONFIG_CFG80211_WEXT]
#    <*/M> Generic IEEE 802.11 Networking Stack (mac80211) [CONFIG_MAC80211]
#Device Drivers  --->
#  [*] Network device support  --->                        [CONFIG_NETDEVICES]
#    [*] Wireless LAN  --->                                [CONFIG_WLAN]
#

cat > wpa_supplicant/.config << "EOF"
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE=y
CONFIG_DEBUG_FILE=y
CONFIG_DEBUG_SYSLOG=y
CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
CONFIG_DRIVER_NL80211=y
CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_EAP_GTC=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_OTP=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TLS=y
CONFIG_EAP_TTLS=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_IPV6=y
CONFIG_LIBNL32=y
CONFIG_PEERKEY=y
CONFIG_PKCS12=y
CONFIG_READLINE=y
CONFIG_SMARTCARD=y
CONFIG_WPS=y
CFLAGS += -I/usr/include/libnl3
EOF

cat >> wpa_supplicant/.config << "EOF"
CONFIG_CTRL_IFACE_DBUS=y
CONFIG_CTRL_IFACE_DBUS_NEW=y
CONFIG_CTRL_IFACE_DBUS_INTRO=y
EOF

cd wpa_supplicant &&
make BINDIR=/sbin LIBDIR=/lib

pushd wpa_gui-qt4 &&
qmake wpa_gui.pro &&
make &&
popd

mkdir -p $P/sbin
mkdir -p $P/usr/share/man/man5/
mkdir -p $P/usr/share/man/man8/

install -v -m755 wpa_{cli,passphrase,supplicant} $P/sbin/ &&
install -v -m644 doc/docbook/wpa_supplicant.conf.5 $P/usr/share/man/man5/ &&
install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 $P/usr/share/man/man8/

mkdir -p $P/lib/systemd/system/
install -v -m644 systemd/*.service /lib/systemd/system/

mkdir -p $P/usr/share/dbus-1/system-services/
mkdir -p $P/etc/dbus-1/system.d

install -v -m644 dbus/fi.w1.wpa_supplicant1.service \
                 $P/usr/share/dbus-1/system-services/ &&
install -v -d -m755 /etc/dbus-1/system.d &&
install -v -m644 dbus/dbus-wpa_supplicant.conf \
                 $P/etc/dbus-1/system.d/wpa_supplicant.conf


mkdir -p $P/_install
cat > $P/_install/install.sh << "EOF"
systemctl enable wpa_supplicant
update-desktop-database -q

EOF

mkdir -p $P/usr/bin
mkdir -p $P/usr/share/applications/
mkdir -p $P/usr/share/pixmaps/

install -v -m755 wpa_gui-qt4/wpa_gui $P/usr/bin/ &&
install -v -m644 doc/docbook/wpa_gui.8 $P/usr/share/man/man8/ &&
install -v -m644 wpa_gui-qt4/wpa_gui.desktop $P/usr/share/applications/ &&
install -v -m644 wpa_gui-qt4/icons/wpa_gui.svg $P/usr/share/pixmaps/

