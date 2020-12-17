tar -xf ../freetype-doc-2.10.2.tar.xz --strip-components=2 -C docs

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make

make DESTDIR=$P install

install -v -m755 -d $P/usr/share/doc/freetype-2.10.2 &&
cp -v -R docs/*     $P/usr/share/doc/freetype-2.10.2 &&
rm -v $P/usr/share/doc/freetype-2.10.2/freetype-config.1

