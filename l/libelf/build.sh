./configure --prefix=/usr --disable-debuginfod --libdir=/lib

make

make DESTDIR=$P -C libelf install
mkdir -p $P/usr/lib/pkgconfig

install -vm644 config/libelf.pc $P/usr/lib/pkgconfig
rm $P/lib/libelf.a

