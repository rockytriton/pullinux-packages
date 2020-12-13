./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4

make

make DESTDIR=$P install

mkdir -p $P/usr/bin
ln -sv flex $P/usr/bin/lex


