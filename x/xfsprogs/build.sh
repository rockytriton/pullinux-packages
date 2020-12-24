#KMOD
#File systems --->
#  <*/M> XFS filesystem support [CONFIG_XFS_FS]


make DEBUG=-DNDEBUG     \
     INSTALL_USER=root  \
     INSTALL_GROUP=root

make DESTDIR=$P PKG_DOC_DIR=/usr/share/doc/xfsprogs-5.7.0 install     &&
make DESTDIR=$P PKG_DOC_DIR=/usr/share/doc/xfsprogs-5.7.0 install-dev &&

rm -rfv $P/usr/lib/libhandle.a                                &&
rm -rfv $P/lib/libhandle.{a,la,so}                            &&
ln -sfv ../../lib/libhandle.so.1 $P/usr/lib/libhandle.so

