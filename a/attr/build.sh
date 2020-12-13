./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48

make

make DESTDIR=$P install

mkdir -p $P/lib
mv -v $P/usr/lib/libattr.so.* $P/lib
ln -sfv ../../lib/$(readlink $P/usr/lib/libattr.so) $P/usr/lib/libattr.so

