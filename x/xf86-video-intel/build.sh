./autogen.sh $XORG_CONFIG     \
            --enable-kms-only \
            --enable-uxa      \
            --mandir=/usr/share/man &&
make
make DESTDIR=$P install

mkdir -p $P/etc/X11/xorg.conf.d
cat >> /etc/X11/xorg.conf.d/20-intel.conf << "EOF"
Section   "Device"
        Identifier "Intel Graphics"
        Driver     "intel"
        #Option     "DRI" "2"            # DRI3 is default
        #Option     "AccelMethod"  "sna" # default
        #Option     "AccelMethod"  "uxa" # fallback
EndSection
EOF

