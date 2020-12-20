mkdir -v build &&
cd       build &&

cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DBUILD_STATIC_LIBS=OFF .. &&
make

make DESTDIR=$P install &&

pushd ../doc &&
  for man in man/man?/* ; do
      install -v -D -m 644 $man $P/usr/share/$man
  done
popd

