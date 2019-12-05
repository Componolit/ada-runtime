#!/bin/sh

cd /muen
git reset --hard
git fetch --all
git checkout 0b00af04d5de485c4bbb9aff2393472a180e7499
rm -r components/spark_runtime/src
ln -sf /app components/spark_runtime/src
make -j$(nproc)
set -e
make -C components/spark_runtime
