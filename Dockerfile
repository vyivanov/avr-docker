FROM ubuntu:latest
MAINTAINER Vladimir Ivanov, inbox@vova-ivanov.info

ENV PATH $PATH:/usr/local/avr/bin

RUN \
    #### install build tools ####
    apt-get update && apt-get install -y --no-install-recommends \
                      wget \
                      make \
                      build-essential \
                      libmpc-dev \
                      libmpfr-dev \
                      libgmp3-dev \
 && mkdir /usr/local/avr /opt/distr && cd /opt/distr \
    #### build and install cmake-3.3.2 ####
 && wget http://vova-ivanov.info/avr_tc/cmake-3.3.2.tar.gz \
 && tar -zxvf cmake-3.3.2.tar.gz && cd cmake-3.3.2 \
 && ./bootstrap && make && make install && cd .. \
    #### build and install binutils-2.25.1 ####
 && wget http://vova-ivanov.info/avr_tc/binutils-2.25.1.tar.bz2 \
 && bunzip2 -c binutils-2.25.1.tar.bz2 | tar xf - && cd binutils-2.25.1 \
 && mkdir build && cd build \
 && ../configure --prefix=/usr/local/avr --target=avr --disable-nls \
 && make && make install && cd ../.. \
    #### build and install gcc-5.2.0 ####
 && wget http://vova-ivanov.info/avr_tc/gcc-5.2.0.tar.bz2 \
 && bunzip2 -c gcc-5.2.0.tar.bz2 | tar xf - && cd gcc-5.2.0 \
 && mkdir build && cd build \
 && ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 \
 && make && make install && cd ../.. \
    #### build and install libc-1.8.1 ####
 && wget http://vova-ivanov.info/avr_tc/avr-libc-1.8.1.tar.bz2 \
 && bunzip2 -c avr-libc-1.8.1.tar.bz2 | tar xf - && cd avr-libc-1.8.1 \
 && ./configure --prefix=/usr/local/avr --build=`./config.guess` --host=avr \
 && make && make install && cd .. \
    #### clean up the image ####
 && cd .. && rm -rf distr \
 && apt-get remove -y \
    wget \
    make \
    build-essential \
    libmpc-dev \
    libmpfr-dev \
    libgmp3-dev \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/bin/bash"]

