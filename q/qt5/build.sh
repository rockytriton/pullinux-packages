mkdir -p $P/opt/qt-5.15.0
ln -sfnv qt-5.15.0 $P/opt/qt5

sed -i 's/python /python3 /' qtdeclarative/qtdeclarative.pro \
                             qtdeclarative/src/3rdparty/masm/masm.pri &&

./configure -prefix $QT5PREFIX                        \
            -sysconfdir /etc/xdg                      \
            -confirm-license                          \
            -opensource                               \
            -dbus-linked                              \
            -openssl-linked                           \
            -system-harfbuzz                          \
            -system-sqlite                            \
            -nomake examples                          \
            -no-rpath                                 \
            -skip qtwebengine                         &&
make

make DESTDIR=$P install

find $P$QT5PREFIX/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

QT5BINDIR=$QT5PREFIX/bin

install -v -dm755 $P/usr/share/pixmaps/                  &&

install -v -Dm644 qttools/src/assistant/assistant/images/assistant-128.png \
                  $P/usr/share/pixmaps/assistant-qt5.png &&

install -v -Dm644 qttools/src/designer/src/designer/images/designer.png \
                  $P/usr/share/pixmaps/designer-qt5.png  &&

install -v -Dm644 qttools/src/linguist/linguist/images/icons/linguist-128-32.png \
                  $P/usr/share/pixmaps/linguist-qt5.png  &&

install -v -Dm644 qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png \
                  $P/usr/share/pixmaps/qdbusviewer-qt5.png &&

install -dm755 $P/usr/share/applications &&

cat > $P/usr/share/applications/assistant-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=$QT5BINDIR/assistant
Icon=assistant-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF

cat > $P/usr/share/applications/designer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=$QT5BINDIR/designer
Icon=designer-qt5.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

cat > $P/usr/share/applications/linguist-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Linguist
Comment=Add translations to Qt5 applications
Exec=$QT5BINDIR/linguist
Icon=linguist-qt5.png
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

cat > $P/usr/share/applications/qdbusviewer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 QDbusViewer
GenericName=D-Bus Debugger
Comment=Debug D-Bus applications
Exec=$QT5BINDIR/qdbusviewer
Icon=qdbusviewer-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Debugger;
EOF

mkdir -p $P/usr/bin

for file in moc uic rcc qmake lconvert lrelease lupdate; do
  ln -sfrvn $QT5BINDIR/$file $P/usr/bin/$file-qt5
done

mkdir -p $P/etc/sudoers.d
cat > $P/etc/sudoers.d/qt << "EOF"
Defaults env_keep += QT5DIR
EOF

mkdir -p $P/etc/ld.so.conf.d
cat > /etc/ld.so.conf.d/qt5.conf << EOF
/opt/qt5/lib
EOF

mkdir -p $P/etc/profile.d
cat > $P/etc/profile.d/qt5.sh << "EOF"
# Begin /etc/profile.d/qt5.sh

QT5DIR=/opt/qt5

pathappend $QT5DIR/bin           PATH
pathappend $QT5DIR/lib/pkgconfig PKG_CONFIG_PATH

export QT5DIR

# End /etc/profile.d/qt5.sh
EOF

mkdir -p $P/_install
cat > $P/_install/install.sh << EOF
ldconfig

EOF

