FROM alpine:edge

RUN apk update && apk upgrade && apk add --no-cache \
    strongswan \
    ipsec \
    openssl \
    bash

COPY entrypoint.sh /entrypoint.sh
COPY ipsec/ipsec.conf /etc/ipsec.conf
COPY ipsec/ipsec.secrets /etc/ipsec.secrets

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
