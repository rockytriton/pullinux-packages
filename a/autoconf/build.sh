sed -i '361 s/{/\\{/' bin/autoscan.in

./configure --prefix=/usr

make

make DESTDIR=$P install

