gzip -cd ../libpng-1.6.37-apng.patch.gz | patch -p1

./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install

mkdir -pv /usr/share/doc/libpng-1.6.37 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.37

