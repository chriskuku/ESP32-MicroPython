#!/bin/bash
set -e

SRC="/mnt/src"
BUILD="/mnt/build"
mkdir -p ${BUILD} || :
rm -r "${BUILD}/*" || :

if [ -d "$SRC" ]; then
  cp -r ${SRC}/* /micropython/ports/esp32/modules || :
fi

make ${MAKEOPTS} $@ -C /micropython/ports/esp32
cp -r /micropython/ports/esp32/build-*/*.bin ${BUILD}
