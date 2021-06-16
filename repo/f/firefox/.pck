name: firefox
version: 78.8.0
repo: core
source: https://archive.mozilla.org/pub/firefox/releases/78.8.0esr/source/firefox-78.8.0esr.source.tar.xz
deps: [
  'autoconf-old',
  'cbindgen',
  'dbus-glib',
  'gtk+3',
  'gtk+2',
  'libnotify',
  'llvm',
  'nodejs',
  'nss',
  'pulseaudio',
  'alsa-lib',
  'startup-notification',
  'unzip',
  'icu',
  'libevent',
  'libwebp',
  'ffmpeg',
]
extras: []
mkdeps: [
  'yasm', 'zip', 'nasm', 'rustc'
]
