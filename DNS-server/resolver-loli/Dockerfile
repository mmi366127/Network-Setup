FROM ubuntu:latest

RUN apt update  
RUN apt install -y bind9 bind9utils bind9-doc
RUN apt install -y net-tools iputils-ping 

COPY named.conf.options /etc/bind/
COPY named.conf.default-zones /etc/bind
COPY loli/loli.hosts /etc/bind/loli.hosts
COPY loli/loli.rev /etc/bind/loli.rev

EXPOSE 53/udp
EXPOSE 53/tcp

CMD ["/usr/sbin/named", "-g"]
