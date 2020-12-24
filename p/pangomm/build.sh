sed -e '/^libdocdir =/ s/$(book_name)/pangomm-2.42.1/' \
    -i docs/Makefile.in

./configure --prefix=/usr &&
make
make DESTDIR=$P install

