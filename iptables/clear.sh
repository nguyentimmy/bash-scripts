#!/bin/bash 

# Must run as root
if [[ $UID != 0 ]]; then
        echo "[+] Must run as ROOT!"
        exit
fi

# Clearing current rules and adding default policies 
echo -e '\n[+] Flushing & Deleting Rules ...'
iptables -F && iptables -X
iptables -t nat -F && iptables -t nat -X
iptables -t mangle -F && iptables -t mangle -X
sleep 1

echo -e "\n[+] Allowing reconnection, opening up all traffic ..."
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
sleep 1

echo -e "\n[+] Iptables cleared:\n"
iptables -L -nv --line-numbers
