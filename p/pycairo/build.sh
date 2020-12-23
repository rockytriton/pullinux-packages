python3 setup.py build

python3 setup.py install --optimize=1 --root=$P   &&
python3 setup.py install_pycairo_header --root=$P &&
python3 setup.py install_pkgconfig --root=$P

