
DESTDIR=
EXTDIR=${DESTDIR}/etc
DEFAULTSDIR=${DESTDIR}/etc/default
SERVICEDIR=${DESTDIR}/lib/services
TMPFILESDIR=${DESTDIR}/usr/lib/tmpfiles.d
UNITSDIR=${DESTDIR}/lib/systemd/system
MODE=755
DIRMODE=755
CONFMODE=644

install -d -m ${DIRMODE} ${DEFAULTSDIR}
install -d -m ${DIRMODE} ${TMPFILESDIR}
install -d -m ${DIRMODE} ${UNITSDIR}

install -m ${CONFMODE} saslauthd ${DEFAULTSDIR}/
install -m ${CONFMODE} saslauthd.conf ${TMPFILESDIR}/
install -m ${CONFMODE} saslauthd.service ${UNITSDIR}/

systemd-tmpfiles --create saslauthd.conf
systemctl enable saslauthd.service

