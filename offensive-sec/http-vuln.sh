#!/bin/bash
 
# ENTER ANY HTTP SCRIPTS ON /usr/share/nmap/scripts
HTTP=http-enum,http-waf-detect,http-grep,http-wordpress-enum,http-brute
 
# ONLY ROOT CAN ONLY CAN RUN SCRIPT
if [[ $UID != 0 ]]
then
   echo "[+] YOU MUST BE ROOT TO RUN THIS SCRIPT!"
   exit
fi
 
# INSTALLING NIKTO IF UNAVAILABLE
if [[ ! -f /usr/bin/nikto || ! -f /usr/bin/nmap ]]
then
   echo "[+] DEPENDENCIES IS UNAVAILABLE IN YOUR SYSTEM..."
   echo "[+] INSTALLING PACKAGES..."
   apt install nikto -yy  && apt install nmap -yy
fi
 
# INPUT THE IP OR SUBNET [USE POSITIONAL PARAMETERS FOR MORE INPUTS]
echo -e "\n[+] ENTER AN IP OR SUBNET:"
read -p "-> " IP
 
# NMAP SCAN ON PORT HTTP 80
echo -e "\n[+] NMAP SCANNING ON $ip FOR  PORT 80"
nmap -p80 --script=${HTTP} ${IP} -oG NIKTO.TXT -oN  NMAP.TXT > /dev/null
if grep -q  "open" NIKTO.TXT > /dev/null
then
    echo -e "-> TCP PORT 80 FOUND!"
else
    echo -e "-> TCP PORT 80 UNAVAILABLE!\n-> EXITING SCRIPT"
    exit
fi
 
# INPUTTING THE TARGET IP INTO A TEXT FILE
echo -e "\n[+] INPUTTING TARGET IP ON NIKTO.TXT"
cat NIKTO.TXT | awk '/Up$/{print $2}'  > TARGET.TXT
echo -e "-> SUCCESSFULLY GENERATED NIKTO.TXT ON $PWD"
 
 
# WEB SCANNING USING NIKTO ON TARGET AND OUTPUTTING RESULTS
echo -e "\n[+] SCANNING TARGET WITH NIKTO (MAY TAKE UP TO 10-15 SECS)"
nikto -h TARGET.TXT >> NIKTO.TXT
echo "-> SUCCESSFULLY CREATED REPORT.TXT"
 

