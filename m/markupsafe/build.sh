if command -v python2; then
	python2 setup.py build
	python2 setup.py bdist

	tar -xf dist/*.gz -C $P/
fi

python3 setup.py build
python3 setup.py bdist

tar -xf dist/*.gz -C $P/


