patch -Np1 -i ../libarchive-3.4.3-testsuite_fix-1.patch

./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install

