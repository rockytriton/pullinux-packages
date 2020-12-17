mkdir build &&
cd    build &&

meson  --prefix=/usr --sysconfdir=/etc -Dfribidi=false .. &&
ninja
DESTDIR=$P ninja install

rm -v $P/etc/profile.d/vte.*

