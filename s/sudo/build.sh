./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.2 \
            --with-passprompt="[sudo] password for %p: " &&
make

make DESTDIR=$P install

ln -sfv libsudo_util.so.0.0.0 $P/usr/lib/sudo/libsudo_util.so.0

