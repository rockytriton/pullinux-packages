sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap &&
printf '\tkbs=\\177,\n' >> terminfo &&

TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG     \
    --with-app-defaults=/etc/X11/app-defaults &&

make
make DESTDIR=$P install    &&
make DESTDIR=$P install-ti &&

mkdir -pv $P/usr/share/applications &&
cp -v *.desktop $P/usr/share/applications/

