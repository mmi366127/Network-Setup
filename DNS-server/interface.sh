

ID=9
interface=eth0

sudo modprobe macvlan
sudo ip link set $interface promisc on

docker network create -d macvlan --subnet 192.168.254.0/24 --gateway 192.168.$ID.254 -o parent=$interface -o macvlan_mode=bridge dns-network

sudo ip link add dns-server link eth0 type macvlan  mode bridge

sudo ip link set dns-server up
sudo ip route add 192.168.9.53 dev dns-server
sudo ip route add 192.168.9.153 dev dns-server

