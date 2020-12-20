cargo build --release

mkdir -p $P/usr/bin

install -Dm755 target/release/cbindgen $P/usr/bin/

