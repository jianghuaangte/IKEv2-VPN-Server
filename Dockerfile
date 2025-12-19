FROM alpine:3.20

RUN apk update && apk upgrade && apk add --no-cache \
    strongswan \
    strongswan-eap \
    strongswan-pki \
    openssl \
    bash

COPY entrypoint.sh /entrypoint.sh
COPY ipsec.conf /etc/ipsec.conf
COPY ipsec.secrets /etc/ipsec.secrets

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
