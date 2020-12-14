patch -Np1 -i ../bash-5.0-upstream_fixes-1.patch

./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline

make

make DESTDIR=$P install
mkdir -p $P/bin

mv -vf $P/usr/bin/bash $P/bin

