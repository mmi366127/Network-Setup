#!/bin/bash

ID=9
interface=eth0

sudo modprobe macvlan
sudo ip link set $interface promisc on

if [[ $(sudo docker network ls) == *"test"* ]]; then
    docker network create -d macvlan --subnet 192.168.$ID.0/24 --gateway 192.168.$ID.254 -o parent=$interface -o macvlan_mode=bridge dns-network
fi

sudo ip link add dns-server link eth0 type macvlan  mode bridge

sudo ip link set dns-server up
sudo ip route add 192.168.$ID.53 dev dns-server
sudo ip route add 192.168.$ID.153 dev dns-server

