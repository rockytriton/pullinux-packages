patch -Np1 -i ../glibc-2.32-fhs-1.patch

mkdir -pv $P/lib
mkdir -pv $P/etc

mkdir -v build
cd       build

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/lib

make

case $(uname -m) in
  i?86)   ln -sfnv $PWD/elf/ld-linux.so.2        $P/lib ;;
  x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 $P/lib ;;
esac

sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make DESTDIR=$P install

cp -v ../nscd/nscd.conf $P/etc/nscd.conf
mkdir -pv $P/var/cache/nscd

install -v -Dm644 ../nscd/nscd.tmpfiles $P/usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service $P/lib/systemd/system/nscd.service

mkdir -pv $P/usr/lib/locale
localedef --prefix=$P -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef --prefix=$P -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef --prefix=$P -i de_DE -f ISO-8859-1 de_DE
localedef --prefix=$P -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef --prefix=$P -i de_DE -f UTF-8 de_DE.UTF-8
localedef --prefix=$P -i el_GR -f ISO-8859-7 el_GR
localedef --prefix=$P -i en_GB -f UTF-8 en_GB.UTF-8
localedef --prefix=$P -i en_HK -f ISO-8859-1 en_HK
localedef --prefix=$P -i en_PH -f ISO-8859-1 en_PH
localedef --prefix=$P -i en_US -f ISO-8859-1 en_US
localedef --prefix=$P -i en_US -f UTF-8 en_US.UTF-8
localedef --prefix=$P -i es_MX -f ISO-8859-1 es_MX
localedef --prefix=$P -i fa_IR -f UTF-8 fa_IR
localedef --prefix=$P -i fr_FR -f ISO-8859-1 fr_FR
localedef --prefix=$P -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef --prefix=$P -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef --prefix=$P -i it_IT -f ISO-8859-1 it_IT
localedef --prefix=$P -i it_IT -f UTF-8 it_IT.UTF-8
localedef --prefix=$P -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef --prefix=$P -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef --prefix=$P -i tr_TR -f UTF-8 tr_TR.UTF-8

cat > $P/etc/nsswitch.conf << "EOF"

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

EOF

#https://www.iana.org/time-zones/repository/releases/tzdata2020a.tar.gz
tar -xf ../../tzdata2020a.tar.gz

ZONEINFO=$P/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/Chicago
unset ZONEINFO

ln -sfv /usr/share/zoneinfo/America/Chicago $P/etc/localtime

cat > $P/etc/ld.so.conf << "EOF"
/usr/local/lib
/opt/lib
include /etc/ld.so.conf.d/*.conf

EOF

mkdir -pv $P/etc/ld.so.conf.d

mkdir -p $P/lib64
ln -sfv ../lib/ld-linux-x86-64.so.2 $P/lib64/ld-linux-x86-64.so.2
ln -sfv ../lib/ld-linux-x86-64.so.2 $P/lib64/ld-lsb-x86-64.so.3


