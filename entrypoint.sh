#!/bin/bash
set -e
cp -r /modules/* /micropython/ports/esp32/modules || :
make ${MAKEOPTS} -C ports/esp32
cp /micropython/ports/esp32/build-GENERIC/* /build

exec "$@"
