#!/bin/sh
set -e

CERT_DIR=/etc/ipsec.d
VPN_HOST=${VPN_HOST:?VPN_HOST not set}
VPN_IP=${VPN_IP:?VPN_IP not set}

mkdir -p $CERT_DIR/{private,certs,cacerts}

if [ ! -f "$CERT_DIR/certs/server.crt" ]; then
  echo "[+] Generating CA and server certificate"

  pki --gen --type rsa --size 4096 > $CERT_DIR/private/ca.key
  pki --self --ca \
      --in $CERT_DIR/private/ca.key \
      --dn "CN=IKEv2 VPN CA" \
      --lifetime 3650 \
      > $CERT_DIR/cacerts/ca.crt

  pki --gen --type rsa --size 4096 > $CERT_DIR/private/server.key

  pki --pub --in $CERT_DIR/private/server.key | \
  pki --issue \
      --cacert $CERT_DIR/cacerts/ca.crt \
      --cakey $CERT_DIR/private/ca.key \
      --dn "CN=$VPN_HOST" \
      --san $VPN_HOST \
      --san $VPN_IP \
      --flag serverAuth \
      --flag ikeIntermediate \
      --lifetime 1825 \
      > $CERT_DIR/certs/server.crt
fi

# 生成 EAP 用户
if ! grep -q ": EAP" /etc/ipsec.secrets; then
  echo ": RSA server.key" > /etc/ipsec.secrets
  echo "${VPN_USER} : EAP \"${VPN_PASSWORD}\"" >> /etc/ipsec.secrets
fi

# 打开转发
sysctl -w net.ipv4.ip_forward=1

echo "[+] Starting strongSwan"
exec ipsec start --nofork
