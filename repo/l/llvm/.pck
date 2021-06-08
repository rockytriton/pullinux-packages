name: llvm
version: 11.1.0
repo: core
source: https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/llvm-11.1.0.src.tar.xz
deps: [
  'git',
  'libxml2',
]
mkdeps: [
  'cmake'
]
extras: [
  'https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/clang-11.1.0.src.tar.xz',
  'https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/compiler-rt-11.1.0.src.tar.xz'
]
