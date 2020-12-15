mountpoint -q /dev/shm || mount -t tmpfs devshm /dev/shm

export SHELL=/bin/sh

sed '21,+4d' -i js/moz.configure &&

mkdir obj &&
cd    obj &&

CC=gcc CXX=g++ LLVM_OBJDUMP=/bin/false       \
../js/src/configure --prefix=/usr            \
                    --with-intl-api          \
                    --with-system-zlib       \
                    --with-system-icu        \
                    --disable-jemalloc       \
                    --disable-debug-symbols  \
                    --enable-readline        \
                    --enable-unaligned-private-values &&
make

make DESTDIR=$P install &&
rm -v $P/usr/lib/libjs_static.ajs

