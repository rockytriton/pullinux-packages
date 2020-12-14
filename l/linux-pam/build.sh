sed -e 's/dummy elinks/dummy lynx/'                                     \
    -e 's/-no-numbering -no-references/-force-html -nonumbers -stdin/' \
    -i configure

./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --libdir=/usr/lib                \
            --enable-securedir=/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.4.0 &&
make

install -v -m755 -d $P/etc/pam.d

make DESTDIR=$P install

chmod -v 4755 $P/sbin/unix_chkpwd

mkdir -p $P/lib

for file in pam pam_misc pamc
do
  mv -v $P/usr/lib/lib${file}.so.* $P/lib &&
  ln -sfv ../../lib/$(readlink $P/usr/lib/lib${file}.so) $P/usr/lib/lib${file}.so
done


cat > $P/etc/pam.d/system-account << "EOF" &&
account   required    pam_unix.so

EOF

cat > $P/etc/pam.d/system-auth << "EOF" &&
auth      required    pam_unix.so
auth      optional    pam_cap.so
EOF

cat > $P/etc/pam.d/system-session << "EOF"
session   required    pam_unix.so
session  required    pam_loginuid.so
session  optional    pam_systemd.so

EOF
cat > $P/etc/pam.d/system-password << "EOF"
password  required    pam_unix.so       sha512 shadow try_first_pass

EOF

cat > $P/etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF


