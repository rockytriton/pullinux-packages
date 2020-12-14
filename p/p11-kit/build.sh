sed '20,$ d' -i trust/trust-extract-compat.in &&
cat >> trust/trust-extract-compat.in << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Generate a new trust store
/usr/sbin/make-ca -f -g
EOF

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-trust-paths=/etc/pki/anchors &&
make

make DESTDIR=$P install

mkdir -p $P/usr/bin
mkdir -p $P/usr/lib

ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        $P/usr/bin/update-ca-certificates

ln -sfv ./pkcs11/p11-kit-trust.so $P/usr/lib/libnssckbi.so

