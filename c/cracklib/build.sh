sed -i '/skipping/d' util/packer.c &&

./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/lib/cracklib/pw_dict &&
make
make DESTDIR=$P install
mkdir $P/lib
mv -v $P/usr/lib/libcrack.so.* $P/lib &&
ln -sfv ../../lib/$(readlink $P/usr/lib/libcrack.so) $P/usr/lib/libcrack.so

install -v -m644 -D    ../cracklib-words-2.9.7.bz2 \
                         $P/usr/share/dict/cracklib-words.bz2    &&

bunzip2 -v               $P/usr/share/dict/cracklib-words.bz2    &&
ln -v -sf cracklib-words $P/usr/share/dict/words                 &&
echo $(hostname) >>      $P/usr/share/dict/cracklib-extra-words  &&
install -v -m755 -d      $P/lib/cracklib                         &&

mkdir $P/_install
cat > $P/_install/install.sh << "EOF"
create-cracklib-dict     /usr/share/dict/cracklib-words \
                         /usr/share/dict/cracklib-extra-words

EOF

