sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c &&
./configure --prefix=/usr --disable-static &&
make

make DESTDIR=$P install
mkdir -p $P/usr/bin/

cd examples/.libs &&
for E in *; do
  install -v -m755 $E $P/usr/bin/theora_${E}
done

