### run on cab-pronto-mgt-02 (right) with virtual address 10.64.10.52 routed through management plane interface enp1s0
RIGHT_IFACE1=enp1s0            ### interface of packets arriving to right node
LEFT_SRC1=10.250.156.56         ### IP of left source of packets arriving
LEFT_SRC2=10.250.156.184         ### IP of left source of packets arriving
LEFT_DEST=10.64.10.43        ### IP of left destination for forwarded packets (bottom)
RIGHT_SRC=10.64.10.42           ### IP of right source of forwarded packets (bottom)
sudo iptables -t nat -A PREROUTING -s $LEFT_SRC1 -p tcp -i $RIGHT_IFACE1 --dport 12000 -j CONNMARK --set-mark 0x2
sudo iptables -t nat -A PREROUTING -s $LEFT_SRC2 -p tcp -i $RIGHT_IFACE1 --dport 12020 -j CONNMARK --set-mark 0x3
sudo iptables -t nat -A PREROUTING -p tcp -i $RIGHT_IFACE1 -m connmark --mark 0x2 -j DNAT --to-destination $LEFT_DEST:12010
sudo iptables -t nat -A POSTROUTING -m connmark --mark 0x2 -j SNAT --to-source $RIGHT_SRC
sudo iptables -t nat -L -v -n
#
#On source cab-pronto-mgt-01 (zotac) run   nc 10.64.10.52 12000 (to ue2 mgmt port)
#On destination cab-pronto-mgt-02 (ue2) run nc -l 12020
sudo sysctl net/ipv4/ip_forward=1
echo "check ip_forwarding set to 1"
more /proc/sys/net/ipv4/ip_forward
