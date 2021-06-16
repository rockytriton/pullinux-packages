mkdir -p $LFS/usr/bin
cp src/pullit/pullit $LFS/usr/bin
mkdir -p $LFS/usr/share/plx/{repo,inst,dl-cache,build}
cp -r repo/* $LFS/usr/share/plx/repo/

