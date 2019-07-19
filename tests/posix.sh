#!/bin/sh

set -e
cd /app
make test
make REPORT=all proof
