
EXTDIR=${DESTDIR}/etc
DEFAULTSDIR=${DESTDIR}/etc/default
SERVICEDIR=${DESTDIR}/lib/services
TMPFILESDIR=${DESTDIR}/usr/lib/tmpfiles.d
UNITSDIR=${DESTDIR}/lib/systemd/system
MODE=755
DIRMODE=755
CONFMODE=644

install -m ${CONFMODE} samba ${DEFAULTSDIR}/
install -m ${CONFMODE} samba.conf ${TMPFILESDIR}/
install -m ${CONFMODE} nmbd.service ${UNITSDIR}/
install -m ${CONFMODE} samba.service ${UNITSDIR}/
install -m ${CONFMODE} smbd.service ${UNITSDIR}/
install -m ${CONFMODE} smbdat.service ${UNITSDIR}/smbd@.service
install -m ${CONFMODE} smbd.socket ${UNITSDIR}/
systemd-tmpfiles --create samba.conf
systemctl enable nmbd.service
systemctl enable smbd.service

pip3 install pycryptodome || true

