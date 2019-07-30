#!/bin/sh

set -e
mkdir /genode/contrib/ada-runtime-test
ln -sf /app /genode/contrib/ada-runtime-test/ada-runtime
cd /genode
git remote add jklmnn https://github.com/jklmnn/genode.git
git fetch --all
git checkout 3f0651588ed1c2d432b24276f48a0fc6c8785eb9
./tool/create_builddir x86_64
./tool/ports/prepare_port ada-runtime
ln -sf /genode/contrib/ada-runtime-$(cat /genode/repos/libports/ports/ada-runtime.hash)/ada-runtime-alis /genode/contrib/ada-runtime-test/
echo "test" > /genode/repos/libports/ports/ada-runtime.hash
cd build/x86_64
sed -i "s/^#REPOS/REPOS/g;s/^#MAKE.*$/MAKE += -j$(nproc)/g" etc/build.conf
make run/test KERNEL=linux BOARD=linux PKG=test-spark
make run/test KERNEL=linux BOARD=linux PKG=test-spark_exception
make run/test KERNEL=linux BOARD=linux PKG=test-spark_secondary_stack
/genode/tool/depot/create -j$(nproc) UPDATE_VERSIONS=1 FORCE_BUILD=1 REBUILD=1 \
    genodelabs/pkg/x86_64/test-spark genodelabs/pkg/x86_64/test-spark_exception \
    genodelabs/pkg/x86_64/test-spark_secondary_stack \
    genodelabs/bin/x86_64/depot_query \
    genodelabs/bin/x86_64/fs_rom \
    genodelabs/bin/x86_64/loader \
    genodelabs/bin/x86_64/test-xml_generator \
    genodelabs/bin/x86_64/vfs \
    genodelabs/raw/test-lx_block \
    genodelabs/bin/x86_64/base-linux \
    genodelabs/bin/x86_64/report_rom \
    CROSS_DEV_PREFIX=/usr/local/genode/tool/19.05/bin/genode-x86-
make KERNEL=linux BOARD=linux run/depot_autopilot TEST_PKGS="test-spark test-spark_secondary_stack test-spark_exception"
