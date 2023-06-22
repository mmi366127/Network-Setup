#!/bin/bash


interface=ens18

sudo modprobe macvlan
sudo ip link set $interface promisc on

if [[ $(sudo docker network ls) == *"dns-server"* ]]; then
    docker network create -d macvlan --subnet 192.168.88.0/24 --gateway 192.168.88.1 -o parent=$interface -o macvlan_mode=bridge dns-server
fi

sudo ip link add dns-server link $interface type macvlan mode bridge

sudo ip link set dns-server up
sudo ip route add 192.168.88.53 dev dns-server

