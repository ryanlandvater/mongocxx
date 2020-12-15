## Copyright Ryan Lanvdvater, 2020-2021

FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt -y update \
    && apt -y upgrade

RUN apt install -y \
    openssh-server \
    clang-6.0 \
    cmake \
    git \
    apt-utils \
    pkg-config \
    libssl-dev \
    libsasl2-dev \
    libc++-dev \
    libc++abi-dev
    

#installing boost 1.69
RUN cd ~ \
    && wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.gz \
    && tar xzf boost_1_73_0.tar.gz \
    && cd boost_1_73_0 \
    && ./bootstrap.sh \
    --prefix=/usr/local/ \
    --with-libraries=serialization,thread,system,chrono \
    && ./b2 --show_libraries link=shared threading=multi install \
    && cd ~ \
    && rm boost_1_73_0.tar.gz \
    && rm -rf boost_1_73_0

#installing the mongoc dependencies and driver
RUN cd ~ \
    && wget https://github.com/mongodb/mongo-c-driver/releases/download/1.17.0/mongo-c-driver-1.17.0.tar.gz \
    && tar xzf mongo-c-driver-1.17.0.tar.gz \
    && cd mongo-c-driver-1.17.0 \
    && mkdir cmake-build \
    && cd cmake-build \
    && cmake .. \
    -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF \
    -DCMAKE_C_COMPILER=/usr/bin/clang-6.0 \
    && make install \
    && cd ~ \
    && rm mongo-c-driver-1.17.0.tar.gz \
    && rm -rf mongo-c-driver-1.17.0

#installing mongocxx driver - connects c++ to mongo
RUN cd ~ \
    && wget https://github.com/mongodb/mongo-cxx-driver/releases/download/r3.6.0/mongo-cxx-driver-r3.6.0.tar.gz \
    && tar -xzf mongo-cxx-driver-r3.6.0.tar.gz \
    && cd mongo-cxx-driver-r3.6.0/build \
    && cmake ..  \
    -DCMAKE_BUILD_TYPE=Release  \
    -DBSONCXX_POLY_USE_BOOST=1  \
    -DCMAKE_INSTALL_PREFIX=/usr/local/ \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++-6.0 \
    -DCMAKE_C_COMPILER=/usr/bin/clang-6.0 \
    && make install \
    && cd ~ \
    && rm mongo-cxx-driver-r3.6.0.tar.gz \
    && rm -rf mongo-cxx-driver-r3.6.0
