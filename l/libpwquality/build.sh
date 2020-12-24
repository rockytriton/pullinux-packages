./configure --prefix=/usr                  \
            --disable-static               \
            --with-securedir=/lib/security \
            --with-python-binary=python3 &&
make

make DESTDIR=$P install                          &&
mkdir -p $P/lib
mv -v $P/usr/lib/libpwquality.so.* $P/lib &&
ln -sfv ../../lib/$(readlink $P/usr/lib/libpwquality.so) $P/usr/lib/libpwquality.so


