FROM alpine:3.8 as build

RUN apk add --update --no-cache crystal \
  shards \
  build-base \
  libressl-dev \
  zlib-dev

WORKDIR /opt/relay

COPY shard.yml shard.yml ./

RUN shards install

COPY . ./

RUN shards build --production

FROM alpine:3.8

RUN apk add --update --no-cache crystal \
  openssl

COPY --from=build /opt/relay/bin /usr/local/bin
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN adduser -S relay && \
  install -d -o relay -m 700 /cert

USER relay

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]