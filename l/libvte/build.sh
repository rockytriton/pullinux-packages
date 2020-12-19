./configure --prefix=/usr \
            --libexecdir=/usr/lib/vte \
            --disable-static  &&
make
make DESTDIR=$P install

