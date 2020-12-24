#KMOD
#File systems --->
#  <DOS/FAT/NT Filesystems --->
#    <*/M> MSDOS fs support             [CONFIG_MSDOS_FS]
#    <*/M> VFAT (Windows-95) fs support [CONFIG_VFAT_FS]
#

./configure --prefix=/               \
            --enable-compat-symlinks \
            --mandir=/usr/share/man  \
            --docdir=/usr/share/doc/dosfstools-4.1 &&
make
make DESTDIR=$P install

