# Setup DNS server in docker 
- [homework slide](https://nasa.cs.nycu.edu.tw/na/2023/slides/HW2.pdf)
- run ``./interface.sh`` to create interface for dns docker

## Authoritative DNS server (35%)

- authoritative dns server for zone ``$ID.nasa``
- use ``./auth/build.sh`` to build docker image
- use ``./auth/run.sh`` to run the docker image

## Resolver (65%)

- DNS resolver for zone ``$ID.nasa``
- use ``./resolver/build.sh`` to build docker image
- use ``./resolver/run.sh`` to run the docker image

## Resolver-loli 

The local dns resolver for my LAN.

- 


