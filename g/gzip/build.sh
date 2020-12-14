./configure --prefix=/usr

make

make DESTDIR=$P install

mkdir -pv $P/bin
mv -v $P/usr/bin/gzip $P/bin

