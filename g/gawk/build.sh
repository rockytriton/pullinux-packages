sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

make DESTDIR=$P install

mkdir -pv $P/usr/share/doc/gawk-5.1.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} $P/usr/share/doc/gawk-5.1.0

