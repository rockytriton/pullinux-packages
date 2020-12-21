cd src &&
 
sed -i -e 's@\^u}@^u cols 300}@' tests/dejagnu/config/default.exp     &&
sed -i -e '/eq 0/{N;s/12 //}'    plugins/kdb/db2/libdb2/test/run.test &&

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --with-system-et         \
            --with-system-ss         \
            --with-system-verto=no   \
            --enable-dns-for-realm &&
make
make DESTDIR=$P install

mkdir -p $P/lib
mkdir -p $P/bin

for f in gssapi_krb5 gssrpc k5crypto kadm5clnt kadm5srv \
         kdb5 kdb_ldap krad krb5 krb5support verto ; do

    find $P/usr/lib -type f -name "lib$f*.so*" -exec chmod -v 755 {} \;
done

mv -v $P/usr/lib/libkrb5.so.3*        $P/lib &&
mv -v $P/usr/lib/libk5crypto.so.3*    $P/lib &&
mv -v $P/usr/lib/libkrb5support.so.0* $P/lib &&

ln -v -sf ../../lib/libkrb5.so.3.3        $P/usr/lib/libkrb5.so        &&
ln -v -sf ../../lib/libk5crypto.so.3.1    $P/usr/lib/libk5crypto.so    &&
ln -v -sf ../../lib/libkrb5support.so.0.1 $P/usr/lib/libkrb5support.so &&

mv -v $P/usr/bin/ksu $P/bin &&
chmod -v 755 $P/bin/ksu   &&

install -v -dm755 $P/usr/share/doc/krb5-1.18.2 &&
cp -vfr ../doc/*  $P/usr/share/doc/krb5-1.18.2


