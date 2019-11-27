FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

ENV MAKEOPTS="-j4"
ARG REPOSITORY="https://github.com/micropython/micropython.git"
ARG VERSION="master"

RUN apt-get update && apt-get install -y \
  python3-pip \
  gcc \
  git \
  wget \
  make \
  libncurses-dev \
  flex \
  bison \
  gperf \
  python \
  python-pip \
  python-setuptools \
  python-serial \
  python-cryptography \
  python-future

RUN pip3 install 'pyparsing<2.4'

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --branch ${VERSION} --depth 1 ${REPOSITORY} /micropython

WORKDIR /micropython

RUN TOOLCHAIN=xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz && \
  wget -q https://dl.espressif.com/dl/${TOOLCHAIN} && \
  zcat ${TOOLCHAIN} | tar x && \
  rm ${TOOLCHAIN}

RUN ESPIDF_VERSION=$(grep "ESPIDF_SUPHASH_V3 :=" ports/esp32/Makefile | cut -d " " -f 3) && \
  git clone https://github.com/espressif/esp-idf.git && \
  git -C esp-idf checkout ${ESPIDF_VERSION} && \
  pip3 install -q -r esp-idf/requirements.txt  && \
  git -C esp-idf submodule update --init \
    components/json/cJSON \
    components/esp32/lib \
    components/esptool_py/esptool \
    components/expat/expat \
    components/lwip/lwip \
    components/mbedtls/mbedtls \
    components/micro-ecc/micro-ecc \
    components/nghttp/nghttp2

ENV IDF_PATH "/micropython/esp-idf"
ENV PATH "/micropython/xtensa-esp32-elf/bin:$PATH"

RUN make ${MAKEOPTS} -C mpy-cross
RUN make ${MAKEOPTS} -C ports/esp32 submodules

COPY ./build.sh /micropython/build
RUN chmod u+x /micropython/build

VOLUME [ "/mnt" ]
WORKDIR /mnt
CMD ["/micropython/build"]
