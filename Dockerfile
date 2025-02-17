ARG repo=registry.cn-hangzhou.aliyuncs.com/hextec/ubuntu-18.04
ARG tag=1.1.020210909-RELEASE
ARG arch=x86_64

FROM ${repo}:${tag}-${arch} AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y --no-install-recommends install build-essential wget curl ca-certificates libva-dev python \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && update-ca-certificates

WORKDIR /app
COPY ./build-ffmpeg /app/build-ffmpeg

RUN SKIPINSTALL=yes /app/build-ffmpeg --build --enable-gpl-and-non-free

FROM ${repo}:${tag}-${arch}

ENV DEBIAN_FRONTEND noninteractive

# install va-driver
RUN apt-get update \
    && apt-get -y install libva-drm2 \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy ffmpeg
COPY --from=build /app/workspace/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=build /app/workspace/bin/ffprobe /usr/bin/ffprobe
COPY --from=build /app/workspace/bin/ffplay /usr/bin/ffplay

# Check shared library
RUN ldd /usr/bin/ffmpeg
RUN ldd /usr/bin/ffprobe
RUN ldd /usr/bin/ffplay

