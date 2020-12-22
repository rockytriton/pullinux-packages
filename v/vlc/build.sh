sed -i '/vlc_demux.h/a #define LUA_COMPAT_APIINTCASTS' modules/lua/vlc.h   &&
sed -i '/#include <QWidget>/a\#include <QPainterPath>/'            \
    modules/gui/qt/util/timetooltip.hpp                            &&
sed -i '/#include <QPainter>/a\#include <QPainterPath>/'           \
    modules/gui/qt/components/playlist/views.cpp                   \
    modules/gui/qt/dialogs/plugins.cpp                             &&

BUILDCC=gcc ./configure --prefix=/usr    \
                        --disable-opencv \
                        --disable-vpx    &&

make
make DESTDIR=$P docdir=/usr/share/doc/vlc-3.0.11.1 install

mkdir $P/_install
cat > $P/_install/install.sh << EOF
gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q

EOF

