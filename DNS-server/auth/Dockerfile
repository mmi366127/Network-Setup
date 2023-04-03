FROM ubuntu:latest

RUN apt update  
RUN apt install -y bind9 bind9utils bind9-doc
RUN apt install -y net-tools iputils-ping 

COPY named.conf.options /etc/bind/
COPY named.conf.default-zones /etc/bind
COPY nasa-dnssec/nasa.hosts.signed /etc/bind/nasa.hosts
COPY rev-dnssec/nasa.rev.signed /etc/bind/nasa.rev


EXPOSE 53/udp
EXPOSE 53/tcp

CMD ["/usr/sbin/named", "-g"]
