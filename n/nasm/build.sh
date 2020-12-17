tar -xf ../nasm-2.15.03-xdoc.tar.xz --strip-components=1

./configure --prefix=/usr &&
make

make DESTDIR=$P install

install -m755 -d         /usr/share/doc/nasm-2.15.03/html  &&
cp -v doc/html/*.html    /usr/share/doc/nasm-2.15.03/html  &&
cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.15.03

