patch -Np1 -i ../nss-3.55-standalone-1.patch &&

cd nss &&

make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)

cd ../dist                                                         

mkdir -p $P/usr/lib
mkdir -p $P/usr/bin
mkdir -p $P/usr/lib/pkgconfig

install -v -m755 Linux*/lib/*.so              $P/usr/lib              &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} $P/usr/lib              &&

install -v -m755 -d                           $P/usr/include/nss      &&
cp -v -RL {public,private}/nss/*              $P/usr/include/nss      &&
chmod -v 644                                  $P/usr/include/nss/*    &&

install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} $P/usr/bin &&

install -v -m644 Linux*/lib/pkgconfig/nss.pc  $P/usr/lib/pkgconfig

ln -sfv ./pkcs11/p11-kit-trust.so $P/usr/lib/libnssckbi.so

