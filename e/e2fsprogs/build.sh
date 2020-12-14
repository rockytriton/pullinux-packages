mkdir -v build
cd       build

../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck

make

make DESTDIR=$P install 

chmod -v u+w $P/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

