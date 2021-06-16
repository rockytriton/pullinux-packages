if ! test $(id -u netdev) ; then

groupadd -fg 86 netdev 

cat > /usr/share/polkit-1/rules.d/org.freedesktop.NetworkManager.rules << "EOF"
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("netdev")) {
        return polkit.Result.YES;
    }
});
EOF

fi

systemctl enable NetworkManager
systemctl disable NetworkManager-wait-online

