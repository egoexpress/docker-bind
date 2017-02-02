# docker-bind

Bind Docker Compose setup based on the work of [sameersbn/docker-bind](https://github.com/sameersbn/docker-bind). This image
uses Ubuntu 16.04.1 LTS as a base and installs Bind9 9.10.3 on top.

It uses the network stack of an OpenVPN container (based on [egoexpress/docker-openvpn](https://github.com/egoexpress/docker-openvpn)
running on the same physical host. This container itself uses the host network stack of the server.
Therefore ports 53/tcp and 53/udp are exposed to the VPN and the public interface of the server. Make sure to set the ACLs in
bind to allow queries.
