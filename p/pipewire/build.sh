mkdir build &&
cd    build &&

meson --prefix=/usr           \
      -Djack=false            \
      -Dpipewire-jack=false   \
      -Dvulkan=false          \
      ..                      &&
ninja
DESTDIR=$P ninja install

