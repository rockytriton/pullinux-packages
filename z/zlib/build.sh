./configure --prefix=/usr

make

make DESTDIR=$P install

mkdir -p $P/lib

mv -v $P/usr/lib/libz.so.* $P/lib
ln -sfv ../../lib/$(readlink $P/usr/lib/libz.so) $P/usr/lib/libz.so

