mkdir -p $P/usr

./bootstrap.sh --prefix=$P/usr --with-python=python3 &&
./b2 stage -j4 threading=multi link=shared

./b2 --prefix=$P/usr install threading=multi link=shared

