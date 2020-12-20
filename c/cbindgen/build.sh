cargo build --release

mkdir $P/usr/bin

install -Dm755 target/release/cbindgen $P/usr/bin/

