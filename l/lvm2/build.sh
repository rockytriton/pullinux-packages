#KMOD
#Device Drivers --->
#  [*] Multiple devices driver support (RAID and LVM) ---> [CONFIG_MD]
#    <*/M>   Device mapper support                         [CONFIG_BLK_DEV_DM]
#    <*/M/ >   Crypt target support                        [CONFIG_DM_CRYPT]
#    <*/M/ >   Snapshot target                             [CONFIG_DM_SNAPSHOT]
#    <*/M/ >   Thin provisioning target                    [CONFIG_DM_THIN_PROVISIONING]
#    <*/M/ >   Mirror target                               [CONFIG_DM_MIRROR]
#Kernel hacking --->
#  [*] Magic SysRq key                                     [CONFIG_MAGIC_SYSRQ]

SAVEPATH=$PATH                  &&
PATH=$PATH:/sbin:/usr/sbin      &&
./configure --prefix=/usr       \
            --exec-prefix=      \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync  &&
make                            &&
PATH=$SAVEPATH                  &&
unset SAVEPATH

make DESTDIR=$P install
make DESTDIR=$P install_systemd_units


