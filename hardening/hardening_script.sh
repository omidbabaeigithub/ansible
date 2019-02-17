#!/bin/bash
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -

### Enter Path ###
echo -n "> Enter Full Path for YAML File: "
read path_to_file
### Exit If File Doesn't Exist ###
if ! [[ -e "$path_to_file" ]]; then
	echo "<***Error***> $path_to_file Does Not Exist !"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
	exit
fi
### Exit If File Type Isn't YAML or YML ###
if ! [[ ${path_to_file: -5} == ".yaml" || ${path_to_file: -4} == ".yml" ]]; then
	echo "<***Error***> $path_to_file Is Not YAML/YML File !"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -	
	exit
fi

### Enter hostname ###
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo -n "> Enter Hostname: "
read host_name

### Hardening Command List ###
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo "|  Hardening Command List:                                    |"
echo "|-------------------------------------------------------------|"
echo "|  #   |  COMMAND      |  DESCRIPTION                         |"
echo "|-------------------------------------------------------------|"
echo "|  1   |  CtrlAltDel   |  Disable Ctrl+Alt+Del                |"
echo "|  2   |  firewalld    |  Set Firewalld Rules                 |"
echo "|  3   |  grub         |  Set Password for Grub               |"
echo "|  4   |  ipv6         |  Disable IPv6                        |"
echo "|  5   |  kernel       |  Change kernel Parameters            |"
echo "|  6   |  logwatch     |  Install and Start logwatch Service  |"
echo "|  7   |  partition    |  Change Partition Parameters         |"
echo "|  8   |  psacct       |  Install and Start psacct Service    |"
echo "|  9   |  selinux      |  Selinux Configuration               |"
echo "|  10  |  services     |  Disable Unused Services             |"
echo "|  11  |  ssh          |  Change ssh Configuration            |"
echo "|  12  |  uid          |  Check Users with UID=0              |"
echo "|  13  |  usb          |  Disable USB Stick                   |"
echo "|  14  |  xwindow      |  Remove X Window Package             |"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -

### Enter Tag ###
echo -n "> Enter Hardening Command: "
read tags

### If Tag is Defined ###
if [[ "$tags" =~ ^(CtrlAltDel|uid|xwindow|logwatch|psacct|kernel|ipv6| \
                   |ssh|partition|grub|selinux|firewalld|services|usb)$ ]]; then
    ### If tag = ssh ###
    if [[ $tags == "ssh" ]] ; then
    	echo -n "> Enter Path for SSH Conf. File: "
		read path_to_ssh
  		### If ssh path does not exist ###
		if  [[ -e "$path_to_ssh" ]]; then 
            /usr/bin/ansible-playbook $path_to_file \
            --tags=$tags \
            -e host_name=$host_name \
            -e path_to_ssh=$path_to_ssh
		else 
			echo "<***Error***> $path_to_ssh Does Not Exist !"
			printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
 		fi 
    ### If tag = grub ###
	elif [[ $tags == "grub" ]] ; then
 		### Enter Pass ###
        echo -n "> Enter Grub Password: "
		read -s pass1   
	    echo $''
        ### Renter Pass ###
		echo -n "> Renter Grub Password: "
	    read -s pass2
   		echo $''
        ### If Passwords Match ###
		if [[ $pass1 == $pass2 ]] ; then
    		/usr/bin/ansible-playbook $path_to_file \
			--tags=$tags \
  			-e host_name=$host_name \
	   	    -e grub_pass=$pass1
    	### If Passwords Didn't Match ###
		else
			echo "<***Error***> Passwords Do Not Match !"
			printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
		fi
    ### If tag = firewalld  ###
	elif [[ $tags == "firewalld" ]] ; then
    	echo -n "> Enter Default Zone (public or internal): "
    	read default_zone 
        ### If default_zone = public or internal ###  
		if [[ "$default_zone" =~ ^(public|internal)$ ]]; then
	 		 /usr/bin/ansible-playbook $path_to_file \
        	 --tags=$tags \
      	     -e host_name=$host_name \
             -e default_zone=$default_zone
		### If default_zone Didn't Defined ###
		else 
        	echo  "<***Error***> $default_zone is not in Zones List !"
			printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        fi
    ### If tag != (grub or firewalld) ###    
	else
		/usr/bin/ansible-playbook $path_to_file \
		--tags=$tags \
 	    -e host_name=$host_name
	fi
### If Tag Didn't Defined ###
else
	echo "<***Error***> $tags is not in the Hardening List !"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
fi

