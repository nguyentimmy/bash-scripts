#!/bin/bash 

# Must run as root
if [[ $UID != 0 ]]; then
        echo "[+] Must run as ROOT!"
        exit
fi

# Setting up firewall setting rules 
echo -e '\n[+] Enable TCP SYN cookie protection from SYN floods ...'
sysctl -w net.ipv4.tcp_syncookies=1

echo -e '\n[+] Enable source address spoofing protection ...'
sysctl -w net.ipv4.conf.all.rp_filter=1

echo -e '\n[+] Enables log filtering for impossible source address ...'
sysctl -w net.ipv4.conf.all.log_martians=1

echo -e '\n[+] Drop ICMP echo-request messages sent to broadcast or multicast addresses ...'
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0

echo -e '\n[+] Drop accpeting ICMP echo-request messages ...'
sysctl -w net.ipv4.conf.all.accept_redirects=0

echo -e '\n[+] Clearing all chains ...'
iptables -F

echo -e '\n[+] Allowing outbound traffic ...'
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

echo -e '\n[+] Allowing traffic back on the loopback ...'
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo -e '\n[+] Setting default policies ...'
iptables --policy INPUT DROP
iptables --policy OUTPUT DROP
iptables --policy FORWARD DROP

echo -e '\n[+] Enabling SSH Brute Force Protection ...'
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 7 -j DROP
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

echo -e '\n[+] Dropping other traffic ...'
iptables -A INPUT -j DROP

echo -e '\n[+] Printing out the IPtables rule ...'
iptables -L -nv --line-numbers

echo -e "\n[+] Do you wish to save the rules? [Y/n]"
read A
if [[ $A = '' || $A = 'y' || $A = 'yes' ]]; then
    echo -e "\n[+] Saving sbin tables $(/usr/sbin/iptables-save > /dev/null)"
    echo -e "\n[+] Saving persistent tables\n $(/etc/init.d/netfilter-persistent save | grep -i "done")"
fi
