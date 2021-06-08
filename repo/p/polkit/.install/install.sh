
if ! test $(id -u polkitd) ; then
	groupadd -fg 27 polkitd &&
	useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        	-g polkitd -s /bin/false polkitd
fi

cat > /etc/pam.d/polkit-1 << "EOF"
# Begin /etc/pam.d/polkit-1

auth     include        system-auth
account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/polkit-1
EOF

