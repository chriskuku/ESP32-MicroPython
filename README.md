Build of MicroPython for ESP32 in Docker
===

## Simple one-line compiling

Put your custom `modules` (`main.py` etc.) in `./src` and run

``` sh
docker run -it -v $(pwd):/mnt scrlk/esp32-micropython
```

or use [`docker-compose.yml`](https://github.com/Tymek/ESP32-MicroPython/blob/master/docker-compose.yml) in your project

Firmware will be compiled into `./build`

## Makefile parameters

Inside container:
`/micropython/build BOARD=TINYPICO PART_SRC=/mnt/partitions.csv`
