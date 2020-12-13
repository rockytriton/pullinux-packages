./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5

make

make DESTDIR=$P install

mkdir -p $P/bin
mkdir -p $P/lib

mv -v   $P/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} $P/bin
mv -v $P/usr/lib/liblzma.so.* $P/lib
ln -svf ../../lib/$(readlink $P/usr/lib/liblzma.so) $P/usr/lib/liblzma.so


