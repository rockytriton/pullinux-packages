pck=$1
path=repo/${pck:0:1}/$pck/.pck
sed "s/mkdeps\:\ \[\n/\ /g" $path

