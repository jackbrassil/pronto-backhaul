### run on cab-pronto-mgt-01 (left) to virtual address 10.64.10.52 (virtual mgmt interface of cab-pronto-mgt-02)
LEFT_IFACE=enp2s0		### interface of packets arriving to left node (bottom)
RIGHT_SRC=10.64.10.42	### IP of right source of packets arriving (bottom)
LEFT_SRC1=192.168.0.32		### IP of left source of forward packets hop 2 
LEFT_SRC2=192.168.0.30		### IP of left source of forward packets hop3   change src2 to src3 and src1 to src 2 for consistency
RIGHT_DEST2=10.64.10.53		### IP of right destination for forwarded packets
RIGHT_DEST3=10.64.10.54		### IP of right destination for forwarded packets
sudo iptables -t nat -A PREROUTING -s $RIGHT_SRC -p tcp -i $LEFT_IFACE --dport 12010 -j CONNMARK --set-mark 0x2
sudo iptables -t nat -A PREROUTING -s $RIGHT_SRC -p tcp -i $LEFT_IFACE --dport 12030 -j CONNMARK --set-mark 0x3			#hop3
sudo iptables -t nat -A PREROUTING -p tcp -i $LEFT_IFACE -m connmark --mark 0x2 -j DNAT --to-destination $RIGHT_DEST2:12020
sudo iptables -t nat -A PREROUTING -p tcp -i $LEFT_IFACE -m connmark --mark 0x3 -j DNAT --to-destination $RIGHT_DEST3:12040	#hop3
sudo iptables -t nat -A POSTROUTING -m connmark --mark 0x2 -j SNAT --to-source $LEFT_SRC1
sudo iptables -t nat -A POSTROUTING -m connmark --mark 0x3 -j SNAT --to-source $LEFT_SRC2
sudo iptables -t nat -L -v -n
#
#On source cab-pronto-mgt-01 (zotac) run   nc 10.64.10.52 12000 (to ue2 mgmt port)
#On destination cab-pronto-mgt-02 (ue2) run nc -l 12040  (use 20 for 2 hops, 40 for 3 hops)
sudo sysctl net/ipv4/ip_forward=1
echo "check ip_forwarding set to 1"
more /proc/sys/net/ipv4/ip_forward
