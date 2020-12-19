./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.2 \
            --with-passprompt="[sudo] password for %p: " &&
make

make DESTDIR=$P install

ln -sfv libsudo_util.so.0.0.0 $P/usr/lib/sudo/libsudo_util.so.0

mkdir -p $P/etc/sudoers.d

cat > $P/etc/sudoers.d/sudo << "EOF"
Defaults secure_path="/usr/bin:/bin:/usr/sbin:/sbin"
%wheel ALL=(ALL) ALL
EOF

mkdir -p $P/etc/pam.d
cat > $P/etc/pam.d/sudo << "EOF"
# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session
EOF

chmod 644 $P/etc/pam.d/sudo

