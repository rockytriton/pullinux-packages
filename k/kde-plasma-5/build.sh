url=http://download.kde.org/stable/plasma/5.19.4/
wget -r -nH -nd -A '*.xz' -np $url

cat > plasma-5.19.4.md5 << "EOF"
018aa45f5cf8e43e7a20618928affebe  kdecoration-5.19.4.tar.xz
3f371e5e60fb8e884af6c6ee247b0e8d  libkscreen-5.19.4.tar.xz
5cafda895bbfa0c06e93c53616b89700  libksysguard-5.19.4.tar.xz
108b5e62a2abca19fcfa3b4ff8f131f3  breeze-5.19.4.tar.xz
2cb9cf02aa9e3c2b8e676165b99f8774  breeze-gtk-5.19.4.tar.xz
67ac644f6ef96bf5b83066022345b4e0  kscreenlocker-5.19.4.tar.xz
0df5f8e9868151a2899ba81f5dec567b  oxygen-5.19.4.tar.xz
d1ce45d4d530d1257416ad1c0ff0286f  kinfocenter-5.19.4.tar.xz
79a948dbf0bb8c83f1f2ee17efd61385  ksysguard-5.19.4.tar.xz
4be1ba7337efe304d0b41a899edc5dc5  kwayland-server-5.19.4.tar.xz
197cadd24436310957258d2b40244ae8  kwin-5.19.4.tar.xz
15d58fbcfcf42d86629af7a77860e5a3  plasma-workspace-5.19.4.tar.xz
6a6d4347ea08f7dbce275fec3931bf26  bluedevil-5.19.4.tar.xz
972626bf6107585561f9f6335d3f8e16  kde-gtk-config-5.19.4.tar.xz
b73b47db04afcb39c6a5547fc4b715dc  khotkeys-5.19.4.tar.xz
0b8fa3d76cb2b6f87d3d76884773d5b5  kmenuedit-5.19.4.tar.xz
60223cfe9581d0913a421877a1946dab  kscreen-5.19.4.tar.xz
a89d3e90f4595b2acb7d911584f1883d  kwallet-pam-5.19.4.tar.xz
b471f4de79180257d05baebb6b9b587e  kwayland-integration-5.19.4.tar.xz
96faee06be1d88890c421b4d6334b783  kwrited-5.19.4.tar.xz
edcdefa304ed8df4d89e2bb48cb1cdd2  milou-5.19.4.tar.xz
a5af79f15adec8b2dd19ce286e575691  plasma-nm-5.19.4.tar.xz
f6eff79bb6a683e66208228ff566c116  plasma-pa-5.19.4.tar.xz
569c55902960eda4658634bac40dd22e  plasma-workspace-wallpapers-5.19.4.tar.xz
0a3f401968a27c3ae5caec07064c2343  polkit-kde-agent-1-5.19.4.tar.xz
9a2c2cbd8df0d5ce5133b842fa5ed636  powerdevil-5.19.4.tar.xz
1f1ea5c20ef9b90f106a2d25a7128a35  plasma-desktop-5.19.4.tar.xz
a8fefae0ae99a25f31c798b921d42564  kdeplasma-addons-5.19.4.tar.xz
3344cda599e9a33c510c9113f9da3948  kgamma5-5.19.4.tar.xz
e490ae9cef3e092124047dbbbcf0a3e5  ksshaskpass-5.19.4.tar.xz
#e211c0b303736f2c913f7eee4b112792  plasma-sdk-5.19.4.tar.xz
da829188c6b8c5116cb156b388adf1b8  sddm-kcm-5.19.4.tar.xz
0787296981e74adb829df253e6cd8a82  user-manager-5.19.4.tar.xz
99e3c88039d905aeee25984807d04f22  discover-5.19.4.tar.xz
#70f67b313e08ff3735c5dabcc4d34d2f  breeze-grub-5.19.4.tar.xz
#a38f1c99c6f43ce767a978319f87a011  breeze-plymouth-5.19.4.tar.xz
c2340132ae128347a83fa8748a46ed9d  kactivitymanagerd-5.19.4.tar.xz
10fea9aa0c4a74dce276bd006f56fdc0  plasma-integration-5.19.4.tar.xz
7645d39b27be8f378b2fe66a9e7a4734  plasma-tests-5.19.4.tar.xz
#74b4d61d44f5181e06fb5ae467f84d2d  plymouth-kcm-5.19.4.tar.xz
a4831d1a9f75b378e690daa07a543a88  xdg-desktop-portal-kde-5.19.4.tar.xz
39c97b134ab62d432187b2fadccacc11  drkonqi-5.19.4.tar.xz
b74993d79c92e8e39cf4910b2401c8f2  plasma-vault-5.19.4.tar.xz
b43af2c7267fcfd591c9b3d1b94dfa80  plasma-browser-integration-5.19.4.tar.xz
d0aa151e8dfe37bc412bf4a9fdfa027d  kde-cli-tools-5.19.4.tar.xz
5d0d2934a79dcd46e10165812ea69cc9  systemsettings-5.19.4.tar.xz
3e05594393cba476cf41c9001fe152f5  plasma-thunderbolt-5.19.4.tar.xz
#6fcb468827748d81a3d79a862e80ee52  plasma-nano-5.19.4.tar.xz
#13d0a1017e9a44fc91b27147866ff36b  plasma-phone-components-5.19.4.tar.xz
EOF

while read -r line; do

    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)

    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory

    tar -xf $file
    pushd $packagedir

       # Fix some build issues when generating some configuration files
       case $name in
         plasma-workspace)
           sed -i '/set.HAVE_X11/a set(X11_FOUND 1)' CMakeLists.txt
         ;;

         khotkeys)
           sed -i '/X11Extras/a set(X11_FOUND 1)' CMakeLists.txt
         ;;

         plasma-desktop)
           sed -i '/X11.h)/i set(X11_FOUND 1)' CMakeLists.txt
         ;;
       esac

       mkdir build
       cd    build

       cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
             -DCMAKE_BUILD_TYPE=Release         \
             -DBUILD_TESTING=OFF                \
             -Wno-dev ..  &&

        make
        make install
	make DESTDIR=$P install
    popd


    rm -rf $packagedir
    /sbin/ldconfig

done < plasma-5.19.4.md5

install -dvm 755 $P/usr/share/xsessions              &&
cd $P/usr/share/xsessions/                                   &&
[ -e plasma.desktop ]                                      ||
ln -sfv $KF5_PREFIX/share/xsessions/plasma.desktop &&
install -dvm 755 $P/usr/share/wayland-sessions       &&
cd $P/usr/share/wayland-sessions/                            &&
[ -e plasmawayland.desktop ]                               ||
ln -sfv $KF5_PREFIX/share/wayland-sessions/plasmawayland.desktop

mkdir -p $P/etc/pam.d
cat > $P/etc/pam.d/kde << "EOF"
# Begin /etc/pam.d/kde

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     include        system-auth

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde
EOF

cat > $P/etc/pam.d/kde-np << "EOF"
# Begin /etc/pam.d/kde-np

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     required       pam_permit.so

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde-np
EOF

cat > $P/etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth    include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF

sed '/^Name=/s/Plasma/Plasma on Xorg/' -i $P/usr/share/xsessions/plasma.desktop

