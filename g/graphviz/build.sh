sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&

autoreconf                            &&
./configure --prefix=/usr PS2PDF=true &&
make

make DESTDIR=$P install

mkdir -p $P/usr/share/doc
ln -v -s $P/usr/share/graphviz/doc $P/usr/share/doc/graphviz-2.44.1

