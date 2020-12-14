sed -r -i '/^char.*parseopt_program_(doc|args)/d' src/parseopt.c

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make

make DESTDIR=$P install

