# ---
# base image (builder)
# see https://hub.docker.com/_/alpine
FROM alpine:3.13.5 AS builder

# define tags to build from
# see https://github.com/jgm/pandoc/tree/2.13
# see https://github.com/pgbouncer/pgbouncer/tree/pgbouncer_1_15_0
ARG PANDOC_TAG=2.13
ARG BUILD_TAG=pgbouncer_1_15_0

# install pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/${PANDOC_TAG}/pandoc-${PANDOC_TAG}-linux-amd64.tar.gz
RUN tar xvzf pandoc-${PANDOC_TAG}-linux-amd64.tar.gz --strip-components 1 -C /usr/local

# install dependencies
# see https://www.pgbouncer.org/install.html
RUN apk --no-cache add \
  make \
  pkgconfig \
  autoconf \
  automake \
  libtool \
  py-docutils \
  git \
  gcc \
  g++ \
  libevent-dev \
  openssl-dev \
  c-ares-dev \
  ca-certificates

# clone git repository
RUN git clone --branch ${BUILD_TAG} --recurse-submodules -j8 \
  https://github.com/pgbouncer/pgbouncer.git /pgbouncer

# define working directory
WORKDIR /pgbouncer

# generate header and configuration files
# see https://www.pgbouncer.org/install.html#building-from-git
RUN ./autogen.sh

# configure, make and install
RUN ./configure --prefix=/pgbouncer
RUN make
RUN make install

# ---
# base image
# see https://hub.docker.com/_/alpine
FROM alpine:3.13.5

# install dependencies
# see https://www.pgbouncer.org/install.html
RUN apk --no-cache add libevent openssl c-ares

# copy sources and binaries
COPY --from=builder /pgbouncer /pgbouncer

# copy userlist files
COPY ./conf/users.txt .

# health check
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD [ "stat", "/tmp/.s.PGSQL.*" ]

# can’t run as root, so choose `nobody`
ENTRYPOINT [ "/pgbouncer/bin/pgbouncer", "-u", "nobody", "/pgbouncer/pgbouncer.ini" ]
