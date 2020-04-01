
set -e

apt update && apt install xz-utils
wget -q https://github.com/jklmnn/gnat-llvm-xtensa/releases/download/20.2-20200228/gnat-llvm-xtensa.tar.xz
tar xvf gnat-llvm-xtensa.tar.xz
export PATH=/gnat-llvm-xtensa/bin:$PATH
cd /app
make esp8266
