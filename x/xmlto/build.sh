LINKS="/usr/bin/links" \
./configure --prefix=/usr &&

make
make DESTDIR=$P install
