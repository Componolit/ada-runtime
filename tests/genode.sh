#!/bin/sh

set -e
mkdir /genode/contrib/ada-runtime-test
ln -sf /app /genode/contrib/ada-runtime-test/ada-runtime
cd /genode
git remote add jklmnn https://github.com/jklmnn/genode.git
git fetch --all
git checkout 6f8c61bd09fcb9646b1bf4aa69c78e554d7bd966
echo "test" > /genode/repos/libports/ports/ada-runtime.hash
./tool/create_builddir x86_64
cd build/x86_64
sed -i "s/^#REPOS/REPOS/g;s/^#MAKE.*$/MAKE += -j$(nproc)/g" etc/build.conf
make run/test KERNEL=linux BOARD=linux PKG=test-spark
make run/test KERNEL=linux BOARD=linux PKG=test-spark_exception
make run/test KERNEL=linux BOARD=linux PKG=test-spark_secondary_stack
