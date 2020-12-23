./configure --prefix=/usr &&
make

mkdir -p $P/usr/lib

make DESTDIR=$P install &&
ln -svfn aspell-0.60 $P/usr/lib/aspell &&

make install
ln -svfn aspell-0.60 /usr/lib/aspell

install -v -m755 -d $P/usr/share/doc/aspell-0.60.8/aspell{,-dev}.html &&

install -v -m644 manual/aspell.html/* \
    $P/usr/share/doc/aspell-0.60.8/aspell.html &&

install -v -m644 manual/aspell-dev.html/* \
    $P/usr/share/doc/aspell-0.60.8/aspell-dev.html

tar -xf ../aspell6-en-2020.12.07-0.tar.bz2

cd aspell6-en-2020.12.07-0
./configure &&
make
make DESTDIR=$P install


