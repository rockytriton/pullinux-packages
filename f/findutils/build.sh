./configure --prefix=/usr --localstatedir=/var/lib/locate

make

make DESTDIR=$P install

mkdir -p $P/bin
mv -v $P/usr/bin/find $P/bin
sed -i 's|find:=${BINDIR}|find:=/bin|' $P/usr/bin/updatedb

