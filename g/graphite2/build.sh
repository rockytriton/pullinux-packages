sed -i '/cmptest/d' tests/CMakeLists.txt

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make

make docs

make DESTDIR=$P install

install -v -d -m755 $P/usr/share/doc/graphite2-1.3.14 &&

cp      -v -f    doc/{GTF,manual}.html \
                    $P/usr/share/doc/graphite2-1.3.14 &&
cp      -v -f    doc/{GTF,manual}.pdf \
                    $P/usr/share/doc/graphite2-1.3.14

