patch -Np1 -i ../gptfdisk-1.0.5-convenience-1.patch &&
sed -i 's|ncursesw/||' gptcurses.cc &&

make
make DESTDIR=$P install

