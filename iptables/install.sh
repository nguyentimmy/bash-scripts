#!/bin/bash

# Must run as root
if [[ $UID != 0 ]]; then
        echo "[+] Must run as ROOT!"
        exit
fi

# Installing IP Tables services if unavailable
if [[ ! -f /sbin/iptables || ! -f /etc/init.d/netfilter-persistent ]]; then
        echo "[+] INSTALLING DEPENDENCIES"
        apt update -yy
        apt install iptables-services -yy
        apt install iptables-persistent -yyy
fi

#systemctl stop firewalld && systemctl disable firewalld

