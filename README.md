
## Docker-Compose

```shell
version: "3.8"

services:
  ikev2:
    image: ikev2-strongswan
    container_name: ikev2
    privileged: true
    network_mode: host
    restart: unless-stopped

    environment:
      VPN_HOST: vpn.example.com
      VPN_IP: 1.2.3.4
      VPN_USER: user1
      VPN_PASSWORD: password1

    volumes:
      - ./data:/etc/ipsec.d
```
