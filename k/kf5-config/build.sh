export KF5_PREFIX=/opt/kf5

cat > /etc/profile.d/kf5.sh << "EOF"
export KF5_PREFIX=/opt/kf5

pathappend $KF5_PREFIX/bin              PATH
pathappend $KF5_PREFIX/lib/pkgconfig    PKG_CONFIG_PATH

pathappend $KF5_PREFIX/etc/xdg          XDG_CONFIG_DIRS
pathappend $KF5_PREFIX/share            XDG_DATA_DIRS

pathappend $KF5_PREFIX/lib/plugins      QT_PLUGIN_PATH
pathappend $KF5_PREFIX/lib/plugins/kcms QT_PLUGIN_PATH

pathappend $KF5_PREFIX/lib/qml          QML2_IMPORT_PATH

pathappend $KF5_PREFIX/lib/python3.8/site-packages PYTHONPATH

pathappend $KF5_PREFIX/share/man        MANPATH

EOF

cat >> /etc/profile.d/qt5.sh << "EOF"
pathappend $QT5DIR/plugins             QT_PLUGIN_PATH
pathappend $QT5DIR/qml                 QML2_IMPORT_PATH

EOF

cat > /etc/ld.so.conf.d/kf5.conf << "EOF"

/opt/kf5/lib

EOF

mkdir -p $P/etc/ld.so.conf.d
mkdir -p $P/etc/profile.d
cp /etc/profile.d/kf5.sh $P/etc/profile.d/kf5.sh
cp /etc/profile.d/qt5.sh $P/etc/profile.d/qt5.sh
cp /etc/ld.so.conf.d/kf5.conf $P/etc/ld.so.conf.d/kf5.conf

install -v -dm755           $KF5_PREFIX/{etc,share} &&
ln -sfv /etc/dbus-1         $KF5_PREFIX/etc         &&
ln -sfv /usr/share/dbus-1   $KF5_PREFIX/share

install -v -dm755           $P$KF5_PREFIX/{etc,share} &&
ln -sfv /etc/dbus-1         $P$KF5_PREFIX/etc         &&
ln -sfv /usr/share/dbus-1   $P$KF5_PREFIX/share

install -v -dm755                $KF5_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $KF5_PREFIX/share/icons

install -v -dm755                $P$KF5_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $P$KF5_PREFIX/share/icons



