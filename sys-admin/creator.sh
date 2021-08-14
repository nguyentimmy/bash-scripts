#!/bin/bash

# Prompts for script name and type
read -p "[+] INSERT SCRIPT NAME: " name
echo -e "\n[+] INSERT NUMBER FOR TYPE:\n[1] BASH\n[2] PYTHON\n[3] OTHER\n[4] EXIT!"
read -p "-> " script

# Makes a case statement for the script
case $script in
	1)
	touch ${name}.sh | chmod u+x ${name}.sh | echo "#!/bin/bash" > ${name}.sh 
	var=${name}.sh ;;

	2)
	touch ${name}.py | chmod u+x ${name}.py | echo "#!/usr/bin/python" > ${name}.py 
	read -p "[+] PYTHON 3? [Y/n]: " py
	if [[ py -eq '' ]] || [[ py -eq 'y' ]]; then
		echo "#!/usr/bin/python3" > ${name}.py
	fi
	var=${name}.py ;;

	3)
	read -p "[+] ENTER INTERPRETER: "  type 
	touch ${name}.${type} | chmod u+x ${name}.${type} | echo "#!/usr/bin/${type}" > ${name}.${type}
	var=${name}.${type} ;;

	*)
	echo "BYE!"
	exit 
	;;
esac

echo "[+] ${var} was sucessfully created at $(pwd) on $(date +%D)" 
