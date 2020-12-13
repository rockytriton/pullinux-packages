./configure --prefix=/usr         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53

make

make DESTDIR=$P install

mkdir -p $P/lib
mv -v $P/usr/lib/libacl.so.* $P/lib
ln -sfv ../../lib/$(readlink $P/usr/lib/libacl.so) $P/usr/lib/libacl.so

