
if ! id -u sshd ; then
        groupadd -g 50 sshd
        useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
fi

sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd &&
chmod 644 /etc/pam.d/sshd &&
echo "UsePAM yes" >> /etc/ssh/sshd_config

install -m 644 sshd.service /lib/systemd/system/
install -m 644 sshdat.service /lib/systemd/system/sshd@.service
install -m 644 sshd.socket /lib/systemd/system/

systemctl enable sshd.service

