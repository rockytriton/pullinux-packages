make

mkdir -p $P/usr
mkdir -p $P/lib

make DESTDIR=$P prefix=$P/usr install

rm -v $P/usr/lib/libzstd.a
mv -v $P/usr/lib/libzstd.so.* $P/lib
ln -sfv ../../lib/$(readlink $P/usr/lib/libzstd.so) $P/usr/lib/libzstd.so

