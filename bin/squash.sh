#!/bin/sh

target=$2
mksquashfs /dev/null "${target}.sqfs" -p "/$target f 444 root root cat $1" -comp zstd -Xcompression-level 5
