
cat > /etc/gtk-2.0/gtkrc << "EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "elementary"
EOF

for user in $(ls -1 /home/)
do

cat > /home/$user/.gtkrc-2.0 << "EOF"
include "/usr/share/themes/Glider/gtk-2.0/gtkrc"
gtk-icon-theme-name = "hicolor"
EOF

done;

gtk-query-immodules-2.0 --update-cache
