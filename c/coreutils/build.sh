patch -Np1 -i ../coreutils-8.32-i18n-1.patch

sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

make

make DESTDIR=$P install

mkdir -p $P/bin
mkdir -p $P/usr/sbin
mkdir -p $P/usr/share/man/man8

mv -v $P/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} $P/bin
mv -v $P/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} $P/bin
mv -v $P/usr/bin/{rmdir,stty,sync,true,uname} $P/bin
mv -v $P/usr/bin/chroot $P/usr/sbin
mv -v $P/usr/share/man/man1/chroot.1 $P/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $P/usr/share/man/man8/chroot.8

mv -v $P/usr/bin/{head,nice,sleep,touch} $P/bin

