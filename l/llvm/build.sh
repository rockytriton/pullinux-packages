tar -xf ../clang-10.0.1.src.tar.xz -C tools          &&
tar -xf ../compiler-rt-10.0.1.src.tar.xz -C projects &&

mv tools/clang-10.0.1.src tools/clang &&
mv projects/compiler-rt-10.0.1.src projects/compiler-rt

mkdir -v build &&
cd       build &&

CC=gcc CXX=g++                                  \
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_ENABLE_RTTI=ON                     \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -Wno-dev -G Ninja ..                      &&
ninja

DESTDIR=$P ninja install

