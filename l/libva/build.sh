./configure $XORG_CONFIG &&
make
make DESTDIR=$P install
make install

tar -xvf ../intel-vaapi-driver-2.4.1.tar.bz2 &&
cd intel-vaapi-driver-2.4.1
./configure $XORG_CONFIG &&
make

make DESTDIR=$P install

