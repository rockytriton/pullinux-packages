sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.0

make SHLIB_LIBS="-lncursesw"

make DESTDIR=$P SHLIB_LIBS="-lncursesw" install

mkdir $P/lib

mv -v $P/usr/lib/lib{readline,history}.so.* $P/lib
chmod -v u+w $P/lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink $P/usr/lib/libreadline.so) $P/usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink $P/usr/lib/libhistory.so ) $P/usr/lib/libhistory.so

