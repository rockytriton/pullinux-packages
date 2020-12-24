#KMOD
#[*] Enable loadable module support  --->  [CONFIG_MODULES]
#
#Bus options (PCI etc.)  --->
#  [*] PCI support                         [CONFIG_PCI]
#
#Device Drivers  --->
#  I2C support --->
#    <*/M> I2C device interface            [CONFIG_I2C_CHARDEV]
#    I2C Hardware Bus support  --->
#      <M> (configure all of them as modules)
#  <*/M> Hardware Monitoring support  ---> [CONFIG_HWMON]
#    <M> (configure all of them as modules)

make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man

make DESTDIR=$P PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man install &&

install -v -m755 -d $P/usr/share/doc/lm_sensors-3-6-0 &&
cp -rv              README INSTALL doc/* \
                    $P/usr/share/doc/lm_sensors-3-6-0

