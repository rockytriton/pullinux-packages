export GMAKE_NOWARN=true &&
make -j1 INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root

export GMAKE_NOWARN=true &&
make DESTDIR=$P INS_BASE=/usr MANSUFF_LIB=3cdr DEFINSUSR=root DEFINSGRP=root install

