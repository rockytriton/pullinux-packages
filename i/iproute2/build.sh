sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

sed -i 's/.m_ipt.o//' tc/Makefile

make

make DESTDIR=$P DOCDIR=/usr/share/doc/iproute2-5.8.0 install

