patch -Np1 -i ../autoconf-2.13-consolidated_fixes-1.patch &&
mv -v autoconf.texi autoconf213.texi                      &&
rm -v autoconf.info                                       &&
./configure --prefix=/usr --program-suffix=2.13           &&
make

mkdir -p $P/usr/share/info

make DESTDIR=$P install                                      &&
install -v -m644 autoconf213.info $P/usr/share/info &&
install-info --info-dir=$P/usr/share/info autoconf213.info

