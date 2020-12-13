case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -v build
cd       build

../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib

make

make DESTDIR=$P install
rm -rf $P/usr/lib/gcc/$(gcc -dumpmachine)/10.2.0/include-fixed/bits/

mkdir $P/lib
ln -sv ../usr/bin/cpp $P/lib

install -v -dm755 $P/usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/10.2.0/liblto_plugin.so \
        $P/usr/lib/bfd-plugins/

mkdir -pv $P/usr/share/gdb/auto-load/usr/lib
mv -v $P/usr/lib/*gdb.py $P/usr/share/gdb/auto-load/usr/lib


