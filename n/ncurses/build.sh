sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec

make

make DESTDIR=$P install

mkdir -p $P/lib
mkdir -p $P/usr/lib/pkgconfig
mv -v $P/usr/lib/libncursesw.so.6* $P/lib

ln -sfv ../../lib/$(readlink $P/usr/lib/libncursesw.so) $P/usr/lib/libncursesw.so

for lib in ncurses form panel menu ; do
    rm -vf                    $P/usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > $P/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        $P/usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     $P/usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > $P/usr/lib/libcursesw.so
ln -sfv libncurses.so      $P/usr/lib/libcurses.so

