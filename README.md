## 推荐使用
https://github.com/palw3ey/ye3ipsec  
它同时支持客户端和服务端

### 服务端
```shell
version: '3.8'

networks:
  vpn-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/24
          gateway: 172.21.0.1

  IKEv2-server:
    image: palw3ey/ye3ipsec
    container_name: myipsec
    privileged: true
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
      - SYS_ADMIN
    sysctls:
      net.ipv4.ip_forward: 1
      net.ipv6.conf.all.forwarding: 1
    environment:
      - Y_LOCAL_SELFCERT=yes
      - Y_SERVER_CERT_CN=<server_ip>
      - Y_POOL_IPV4=10.6.1.0/24
      - Y_EAP_USERS=admin:passwd admin2:passwd2   ## 用户名和密码，这里是两个
      - Y_FIREWALL_ENABLE=yes
#      - Y_FIREWALL_NAT=yes
      - Y_FIREWALL_INTERNET=yes
      - Y_FIREWALL_LAN=yes
      - Y_FIREWALL_INTERNET=yes # 允许访问互联网
    volumes:
      - /lib/modules:/lib/modules:ro
    ports:
      - "500:500/udp"
      - "4500:4500/udp"
    networks:
      vpn-network:
        ipv4_address: 172.21.0.20
    restart: unless-stopped
```

手机等设置安装 pem 证书
```shell
docker exec -it myipsec cat /etc/swanctl/x509ca/caCert.pem
```
