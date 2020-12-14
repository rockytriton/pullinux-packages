./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.16 \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd

make
make DESTDIR=$P install

mkdir -p $P/lib
mv -v $P/usr/lib/libprocps.so.* $P/lib
ln -sfv ../../lib/$(readlink $P/usr/lib/libprocps.so) $P/usr/lib/libprocps.so

