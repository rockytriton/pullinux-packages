sed -i 's/test.test/#&/' python/tests/tstLastError.py

./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make

make DESTDIR=$P install

