sed -e '/^libdocdir =/ s/$(book_name)/glibmm-2.64.2/' \
    -i docs/Makefile.in

./configure --prefix=/usr &&
make
make DESTDIR=$P install

