sed -i '/install -m.*STACAPLIBNAME/d' libcap/Makefile

make lib=lib

mkdir -p $P/lib
mkdir -p $P/usr/lib/pkgconfig
mkdir -p $P/usr/lib

make DESTDIR=$P lib=lib PKGCONFIGDIR=$P/usr/lib/pkgconfig install
chmod -v 755 $P/lib/libcap.so.2.42
mv -v $P/lib/libpsx.a $P/usr/lib
rm -v $P/lib/libcap.so
ln -sfv ../../lib/libcap.so.2 $P/usr/lib/libcap.so

