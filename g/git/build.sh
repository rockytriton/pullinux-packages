./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make
make DESTDIR=$P perllibdir=/usr/lib/perl5/5.32/site_perl install
mkdir -p $P/usr/share/man

tar -xf ../git-manpages-2.28.0.tar.xz \
    -C $P/usr/share/man --no-same-owner --no-overwrite-dir

