./configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1 &&
make GETTEXT_PACKAGE=libwnck-1
make DESTDIR=$P GETTEXT_PACKAGE=libwnck-1 install

