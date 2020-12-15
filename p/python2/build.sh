./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes \
            --enable-unicode=ucs4 &&
make

make DESTDIR=$P install &&
chmod -v 755 $P/usr/lib/libpython2.7.so.1.0

mkdir $P/_install
cat > $P/_install/install.sh << "EOF"
python3 -m pip install --force pip

EOF

