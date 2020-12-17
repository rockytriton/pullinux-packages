sed -i 's#) ytasm.*#)#' Makefile.in &&

./configure --prefix=/usr &&
make

make DESTDIR=$P install

