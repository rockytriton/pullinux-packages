./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make

make DESTDIR=$P install

mkdir -p $P/bin
mkdir -p $P/sbin

mv -v $P/usr/bin/{hostname,ping,ping6,traceroute} $P/bin
mv -v $P/usr/bin/ifconfig $P/sbin

