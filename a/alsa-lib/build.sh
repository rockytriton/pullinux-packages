
#KMOD
# Device Drivers --->
#  <*/m> Sound card support --->                  [CONFIG_SOUND]
#    <*/m> Advanced Linux Sound Architecture ---> [CONFIG_SND]
#            Select settings and drivers appropriate for your hardware.
#

./configure &&
make
make DESTDIR=$P install


