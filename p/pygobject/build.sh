mkdir python3                             &&
pushd python3                             &&
  meson --prefix=/usr -Dpython=python3 .. &&
  ninja                                   &&
popd

DESTDIR=$P ninja -C python3 install

