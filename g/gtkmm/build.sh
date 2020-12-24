sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-2.24.5/' \
    -i docs/Makefile.in

./configure --prefix=/usr &&
make
make DESTDIR=$P install

