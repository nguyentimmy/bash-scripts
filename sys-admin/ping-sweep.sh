#/bin/bash

if [[ $1 == "" ]]; then
	echo -e "[+] YOU FORGOT AN IP IN THE PARAMETER\n[+] EXAMPLE: ./pingsweep.sh 192.168.1"
else
	for ip in $(seq 1 254)
	do
		ping -c 1 $1.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":"
	done
fi



