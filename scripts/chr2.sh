echo "using ${LFS:?}"

#mount -v --bind /dev $LFS/dev

#mount -v --bind /dev/pts $LFS/dev/pts
#mount -vt proc proc $LFS/proc
#mount -vt sysfs sysfs $LFS/sys
#mount -vt tmpfs tmpfs $LFS/run

#if [ -h $LFS/dev/shm ]; then
  #mkdir -pv $LFS/$(readlink $LFS/dev/shm)
#fi


chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(plx-chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login

umount $LFS/dev{/pts,}
umount $LFS/{sys,proc,run}

