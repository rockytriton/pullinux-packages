patch -Np1 -i ../lxtask-0.1.9-gcc10_fix-1.patch

./configure --prefix=/usr &&
make
make DESTDIR=$P install

