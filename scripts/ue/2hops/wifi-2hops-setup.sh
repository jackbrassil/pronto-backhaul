### run on cab-pronto-mgt-01 (left) to virtual address 10.64.10.52 (virtual mgmt interface of cab-pronto-mgt-02)
# wifi left node is client with interface wlp4s0 and static IP 10.42.0.101
LEFT_IFACE1=enp2s0		### interface of packets arriving to left node (bottom)
#LEFT_IFACE2=wlp4s0		### interface of packets arriving to left node (wifi)
RIGHT_SRC=10.64.10.42	### IP of right source of packets arriving (bottom)
LEFT_SRC1=10.42.0.101		### IP of left source of forward packets 
RIGHT_DEST2=10.42.0.1		### IP of right destination for forwarded packets
sudo iptables -t nat -A PREROUTING -s $RIGHT_SRC -p tcp -i $LEFT_IFACE1 --dport 12010 -j CONNMARK --set-mark 0x2
sudo iptables -t nat -A PREROUTING -p tcp -i $LEFT_IFACE1 -m connmark --mark 0x2 -j DNAT --to-destination $RIGHT_DEST2:12020
sudo iptables -t nat -A POSTROUTING -m connmark --mark 0x2 -j SNAT --to-source $LEFT_SRC1
sudo iptables -t nat -L -v -n
#
#On source cab-pronto-mgt-01 (zotac) run   nc 10.64.10.52 12000 (to ue2 mgmt port)
#On destination cab-pronto-mgt-02 (ue2) run nc -l 12020
sudo sysctl net/ipv4/ip_forward=1
echo "check ip_forwarding set to 1"
more /proc/sys/net/ipv4/ip_forward
