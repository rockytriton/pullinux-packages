#KMOD
#File systems --->
#  <*/M> Btrfs filesystem support [CONFIG_BTRFS_FS]

./configure --prefix=/usr \
            --bindir=/bin \
            --libdir=/lib &&
make

make DESTDIR=$P install

mkdir -p $P/sbin
mkdir -p $P/usr/lib

ln -sfv ../../lib/$(readlink $P/lib/libbtrfs.so) $P/usr/lib/libbtrfs.so &&
ln -sfv ../../lib/$(readlink $P/lib/libbtrfsutil.so) $P/usr/lib/libbtrfsutil.so &&
rm -fv $P/lib/libbtrfs.{a,so} $P/lib/libbtrfsutil.{a,so} &&
mv -v $P/bin/{mkfs,fsck}.btrfs $P/sbin

