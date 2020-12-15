./configure --prefix=/usr                     \
            --docdir=/usr/share/doc/pcre-8.44 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static                 &&
make

make DESTDIR=$P install
mkdir -p $P/lib

mv -v $P/usr/lib/libpcre.so.* $P/lib &&
ln -sfv ../../lib/$(readlink $P/usr/lib/libpcre.so) $P/usr/lib/libpcre.so

