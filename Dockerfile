FROM ubuntu:latest
MAINTAINER Vladimir Ivanov, inbox@vova-ivanov.info

RUN apt-get update && apt-get install -y \
    make \
    build-essential \
    libmpc-dev \
    libmpfr-dev \
    libgmp3-dev

ADD ./distr/cmake-3.3.2.tar.gz /opt/distr
ADD ./distr/binutils-2.25.1.tar.bz2 /opt/distr
ADD ./distr/gcc-5.2.0.tar.bz2 /opt/distr/
ADD ./distr/avr-libc-1.8.1.tar.bz2 /opt/distr

WORKDIR /opt/distr

RUN cd cmake-3.3.2 && ./bootstrap && make && make install

RUN mkdir /usr/local/avr
ENV PATH $PATH:/usr/local/avr/bin

RUN cd binutils-2.25.1 && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/usr/local/avr --target=avr --disable-nls && \
    make && \
    make install

RUN cd gcc-5.2.0 && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 && \
    make && \
    make install

RUN cd avr-libc-1.8.1 && \
    ./configure --prefix=/usr/local/avr --build=`./config.guess` --host=avr && \
    make && \
    make install

RUN rm -rf cmake-3.3.2 binutils-2.25.1 gcc-5.2.0 avr-libc-1.8.1

ENTRYPOINT ["/bin/bash"]


