#!/bin/sh

cd /muen
git reset --hard
git fetch --all
git checkout 82250b20144be95bc0af4ba266035c24042acccf
rm -r components/spark_runtime/src
ln -sf /app components/spark_runtime/src
make -j$(nproc)
set -e
make -C components/spark_runtime
