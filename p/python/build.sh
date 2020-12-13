./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes

make

make DESTDIR=$P install
chmod -v 755 $P/usr/lib/libpython3.8.so
chmod -v 755 $P/usr/lib/libpython3.so
ln -sfv pip3.8 $P/usr/bin/pip3

python3 -m ensurepip --root $P
