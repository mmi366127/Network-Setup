FROM ubuntu:latest

RUN apt update  
RUN apt install -y bind9 bind9utils bind9-doc
RUN apt install -y net-tools iputils-ping 

COPY cert.pem /etc/bind
COPY key.pem  /etc/bind/ 
COPY named.conf.options /etc/bind/
COPY named.conf.default-zones /etc/bind/



EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 80/tcp
EXPOSE 433/tcp


CMD ["/usr/sbin/named", "-g"]

