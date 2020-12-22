case $(uname -m) in
   i?86) patch -Np1 -i ../SDL2-2.0.12-opengl_include_fix-1.patch ;;
esac
./configure --prefix=/usr &&
make
make DESTDIR=$P install              &&
rm -v $P/usr/lib/libSDL2*.a
