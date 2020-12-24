sed -e '/^libdocdir =/ s/$(book_name)/atkmm-2.28.0/' \
    -i doc/Makefile.in

./configure --prefix=/usr &&
make
make DESTDIR=$P install

