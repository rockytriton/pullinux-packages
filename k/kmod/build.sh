./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib

make

make DESTDIR=$P install

mkdir -p $P/sbin
mkdir -p $P/bin

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod $P/sbin/$target
done

ln -sfv kmod $P/bin/lsmod

