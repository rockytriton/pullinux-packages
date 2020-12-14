echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make

make DESTDIR=$P install

ln -sv vim $P/usr/bin/vi
for L in  $P/usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

mkdir -p $P/usr/share/doc/vim-8.2.1361
ln -sv ../vim/vim82/doc $P/usr/share/doc/vim-8.2.1361

mkdir $P/etc
cat > $P/etc/vimrc << "EOF"
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

EOF

