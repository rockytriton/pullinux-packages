mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr  \
      -DCMAKE_BUILD_TYPE=Release   \
      -DSHARED_ONLY=yes            \
      -DICAL_BUILD_DOCS=false      \
      -DGOBJECT_INTROSPECTION=true \
      -DICAL_GLIB_VAPI=true        \
      .. &&
make
make DESTDIR=$P install

