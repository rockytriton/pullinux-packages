export GMAKE_NOWARN=true &&
make -j1 INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root

export GMAKE_NOWARN=true &&
make DESTDIR=$P INS_BASE=/usr MANSUFF_LIB=3cdr DEFINSUSR=root DEFINSGRP=root install &&
install -v -m755 -d $P/usr/share/doc/cdrtools-3.02a09 &&
install -v -m644 README* ABOUT doc/*.ps \
                    $P/usr/share/doc/cdrtools-3.02a09

