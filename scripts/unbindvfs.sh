echo "using ${LFS:?}"

umount $LFS/dev{/pts,}
umount $LFS/{sys,proc,run}

