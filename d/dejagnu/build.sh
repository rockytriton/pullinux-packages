./configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi

make DESTDIR=$PLX_INST install
install -v -dm755  $PLX_INST/usr/share/doc/dejagnu-1.6.2
install -v -m644   doc/dejagnu.{html,txt} $PLX_INST/usr/share/doc/dejagnu-1.6.2

