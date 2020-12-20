./configure --prefix=/usr &&
make

make DESTDIR=$P install

sed -i 's/Utility;//' $P/usr/share/applications/gpicview.desktop

