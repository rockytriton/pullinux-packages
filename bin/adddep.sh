pck=$1
dep=$2
path=repo/${pck:0:1}/$pck/.pck
sed -i "s/^deps\:\ \[/deps\:\ \[\n  '$dep',/g" $path

