sed -e '/^libdocdir =/ s/$(book_name)/cairomm-1.12.2/' \
    -i docs/Makefile.in

./configure --prefix=/usr &&
make
make DESTDIR=$P install

