FROM caddy:2.6.2-builder-alpine AS builder

RUN xcaddy build --with github.com/caddyserver/forwardproxy@caddy2

FROM caddy:2.6.2-alpine

ADD rootCA.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
