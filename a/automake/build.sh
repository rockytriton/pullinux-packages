sed -i "s/''/etags/" t/tags-lisp-space.sh

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.2

make

make DESTDIR=$P install

