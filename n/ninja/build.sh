sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

python3 configure.py --bootstrap

mkdir -p $P/usr/bin
install -vm755 ninja $P/usr/bin/
install -vDm644 misc/bash-completion $P/usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  $P/usr/share/zsh/site-functions/_ninja

