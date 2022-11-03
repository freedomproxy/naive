# ВЗЯТО С https://github.com/klutchell/dnscrypt-proxy-docker/blob/main/Dockerfile
# Мне лень делать через FROM, проще так добавить строчки.

FROM golang:1.19.2-alpine as build

WORKDIR /go/src/github.com/DNSCrypt/dnscrypt-proxy/

ARG DNSCRYPT_PROXY_VERSION=2.1.2

ENV CGO_ENABLED 0

# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates curl \
        && curl -L "https://github.com/DNSCrypt/dnscrypt-proxy/archive/${DNSCRYPT_PROXY_VERSION}.tar.gz" -o /tmp/dnscrypt-proxy.tar.gz \
        && tar xzf /tmp/dnscrypt-proxy.tar.gz --strip 1 -C /go/src/github.com/DNSCrypt \
        && go build -v -ldflags="-s -w"

WORKDIR /config

# Modification 1: добавлен самопальный CA
ADD rootCA.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

RUN cp -a /go/src/github.com/DNSCrypt/dnscrypt-proxy/example-* ./

# Modification 2: добавлены сертификаты для DoH
COPY dnscrypt-proxy.toml ./
COPY dns.pem ./
COPY dns-key.pem ./

# ----------------------------------------------------------------------------

FROM scratch

COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=build /go/src/github.com/DNSCrypt/dnscrypt-proxy/dnscrypt-proxy /usr/local/bin/
COPY --from=build --chown=nobody:nogroup /config /config

USER nobody

ENTRYPOINT [ "dnscrypt-proxy" ]

CMD [ "-config", "/config/dnscrypt-proxy.toml" ]
