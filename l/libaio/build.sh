sed -i '/install.*libaio.a/s/^/#/' src/Makefile
make
make DESTDIR=$P install
