sed -e '/^libdocdir =/ s/$(book_name)/libsigc++-2.10.3/' -i docs/Makefile.in


./configure --prefix=/usr &&
make

make DESTDIR=$P install

