cat > lua.pc << "EOF"
V=5.4
R=5.4.0

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires:
Libs: -L${libdir} -llua -lm -ldl
Cflags: -I${includedir}
EOF

patch -Np1 -i ../lua-5.4.0-shared_library-1.patch &&
make linux

mkdir -p $P/usr
mkdir -p $P/usr/share/man/man1

make INSTALL_TOP=$P/usr                \
     INSTALL_DATA="cp -d"            \
     INSTALL_MAN=$P/usr/share/man/man1 \
     TO_LIB="liblua.so liblua.so.5.4 liblua.so.5.4.0" \
     install &&

mkdir -pv                      $P/usr/share/doc/lua-5.4.0 &&
cp -v doc/*.{html,css,gif,png} $P/usr/share/doc/lua-5.4.0 &&

install -v -m644 -D lua.pc $P/usr/lib/pkgconfig/lua.pc

