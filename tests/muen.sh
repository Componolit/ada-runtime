#!/bin/sh

cd /muen
git reset --hard
git fetch --all
git checkout d78c4ac4cdbf66dc21eda82b315414eba783adb6
rm -r components/spark_runtime/src
ln -sf /app components/spark_runtime/src
make -j$(nproc)
set -e
make -C components/spark_runtime
