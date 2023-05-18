#!/bin/sh
addOption_string()
{
	/bin/echo "$1" >> "$2"
}

read -p "Admin ID(default:dgist)?" ADMIN_ID
ADMIN_ID=${ADMIN_ID:-"dgist"}

read -p "Enter the NAS IP(default:10.40.4.120)?" NAS_IP
NAS_IP=${NAS_IP:-"10.40.4.120"}
CHECK_PT=$(echo $NAS_IP | tr -cd '.')
CHECK_PT=${#CHECK_PT}
if [ ! ${CHECK_PT} -eq 3 ]; then
	printMsg "Wrong NAS address format"
	exit 1
fi

read -p "Enter the Folder that what you want to connect in NAS(default:dgist)" NAS_FOLDER
NAS_FOLDER=${NAS_FOLDER:-"dgist"}

read -p "Enter the Folder name for connecting in local(default: same with NAS folder)" LOCAL_FOLDER
LOCAL_FOLDER=${LOCAL_FOLDER:-$NAS_FOLDER}
sudo mkdir /media/$LOCAL_FOLDER

read -p "Enter the NAS ID?" NAS_ID
if [ -z $NAS_ID ]; then
	printMsg "Please input NAS ID"
	exit 1
fi

read -p "Enter the NAS password?" NAS_PASS
if [ -z $NAS_PASS ]; then
	printMsg "Please input NAS password"
	exit 1
fi

sudo chown $ADMIN_ID /etc/fstab
addOption_string "//"$NAS_IP"/"$NAS_FOLDER" /media/"$LOCAL_FOLDER" cifs user="$NAS_ID",pass="$NAS_PASS",iocharset=utf8,file_mode=0777,dir_mode=0777,vers=1.0     0     0" /etc/fstab
sudo mount --all