sed -i "s/^PROJECT_LOGO/#&/" doc/doxygen.cfg.in &&

./configure --prefix=/usr --disable-static &&
make -j1

make DESTDIR=$P install

