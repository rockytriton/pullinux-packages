sh autogen.sh                              &&
./configure --prefix=/usr --disable-static &&
make 
make DESTDIR=$P install

