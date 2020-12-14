./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

make

make DESTDIR=$P install

mkdir -p $P/usr/share/bash-completion/completions
mv -v $P/etc/bash_completion.d/grub $P/usr/share/bash-completion/completions

