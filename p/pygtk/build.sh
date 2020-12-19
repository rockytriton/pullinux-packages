sed -i '1394,1402 d' pango.defs

./configure --prefix=/usr &&
make
make DESTDIR=$P install

