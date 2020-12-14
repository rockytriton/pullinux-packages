./configure --prefix=/usr

make

make DESTDIR=$P install

mkdir $P/bin
mv -v $P/usr/bin/fuser   $P/bin
mv -v $P/usr/bin/killall $P/bin

