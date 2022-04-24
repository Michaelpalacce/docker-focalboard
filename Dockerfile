FROM golang AS builder

ARG TARGETARCH
ARG VERSION

RUN apt update
RUN apt install -y git libtool musl-dev autoconf automake bash g++ gcc libpng-dev make nasm lsb-release
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs
RUN git clone -b ${VERSION} --depth 1 https://github.com/mattermost/focalboard.git /focalboard
WORKDIR /focalboard
RUN sed -i "s/GOARCH=amd64/GOARCH=${TARGETARCH}/g" Makefile
RUN npm install -g npm
RUN CPPFLAGS=-DPNG_ARM_NEON_OPT=0 make prebuild
RUN make
RUN make server-linux-package
RUN tar xvzf dist/focalboard-server-*.tar.gz

FROM debian:stable-slim
COPY --from=builder /focalboard/focalboard/ /opt/focalboard/
WORKDIR /opt/focalboard
EXPOSE 8000
CMD /opt/focalboard/bin/focalboard-server