sed -i 's/-lflite"/-lflite -lasound"/' configure &&

./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-avresample  \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --docdir=/usr/share/doc/ffmpeg-4.3.1 &&

make &&

gcc tools/qt-faststart.c -o tools/qt-faststart

make DESTDIR=$P install
mkdir -p $P/usr/bin

install -v -m755    tools/qt-faststart $P/usr/bin &&
install -v -m755 -d           $P/usr/share/doc/ffmpeg-4.3.1 &&
install -v -m644    doc/*.txt $P/usr/share/doc/ffmpeg-4.3.1

