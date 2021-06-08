
if ! id -u ldap ; then
        groupadd -g 83 ldap &&
        useradd  -c "OpenLDAP Daemon Owner" \
         -d /var/lib/openldap -u 83 \
         -g ldap -s /bin/false ldap

fi

sed -e "s/\.la/.so/" -i /etc/openldap/slapd.{conf,ldif}{,.default} &&

install -v -dm700 -o ldap -g ldap /var/lib/openldap     &&

install -v -dm700 -o ldap -g ldap /etc/openldap/slapd.d &&
chmod   -v    640     /etc/openldap/slapd.{conf,ldif}   &&
chown   -v  root:ldap /etc/openldap/slapd.{conf,ldif}

DESTDIR=

EXTDIR=${DESTDIR}/etc
DEFAULTSDIR=${DESTDIR}/etc/default
SERVICEDIR=${DESTDIR}/lib/services
TMPFILESDIR=${DESTDIR}/usr/lib/tmpfiles.d
UNITSDIR=${DESTDIR}/lib/systemd/system
MODE=755
DIRMODE=755
CONFMODE=644

install -m ${CONFMODE} slapd ${DEFAULTSDIR}/
install -m ${CONFMODE} slapd.conf ${TMPFILESDIR}/
install -m ${CONFMODE} slapd.service ${UNITSDIR}/
systemd-tmpfiles --create slapd.conf
systemctl enable slapd.service


