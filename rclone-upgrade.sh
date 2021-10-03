#!/bin/bash
#### Description: Upgrades rclone for debian/ubuntu based distros
####
#### Written by: poneli on 2021 October 3
#### Published on: https://github.com/poneli/
#### =====================================================================
#### <VARIABLES>
latestversion=$(curl -s -L https://rclone.org/downloads/ | awk -F'[ <]' '/Rclone Download/ { print substr($5, 2)}')
currentversion=$(rclone -V | awk -F'[ ]' '/rclone/ { print substr($2, 2)}')
package=$(echo https://downloads.rclone.org/v$latestversion/rclone-v$latestversion-linux-amd64.deb)
downloadfolder="/change/me/example/directory" # No trailing slash
#### </VARIABLES>
if [[ $EUID > 0 ]]; then
	printf -- "Run with sudo... \n";
	exit
fi

if [[ $latestversion > $currentversion ]]; then
	printf -- "Downloading to %s... \n" $downloadfolder;
	wget -q $package -P $downloadfolder
	printf "Installing update... \n";
	dpkg -i $downloadfolder/*.deb &>/dev/null
	if [[ $(rclone -V | awk -F'[ ]' '/rclone/ { print substr($2, 2)}') = $latestversion ]]; then
	  printf -- "rclone upgraded successfully from version %s to %s... \n" $currentversion $latestversion;
	  printf -- "%(%Y-%m-%d %H:%M:%S)T [SUCCESS] rclone upgraded to %s... \n" $(date +%s) $latestversion | tee -a $downloadfolder/update.log >/dev/null;
	  printf -- "Cleaning up %s... \n" $downloadfolder;
	  rm -f $downloadfolder/*.deb
	else
	  printf -- "Installation of rclone %s failed... \nTerminated... \n" $latestversion;
	  printf -- "%(%Y-%m-%d %H:%M:%S)T [ERROR] rclone %s upgrade failed... \n" $(date +%s) $latestversion | tee -a $downloadfolder/update.log >/dev/null;
	fi
else
	printf -- "rclone %s is already installed... \nTerminated... \n" $latestversion;
	printf -- "%(%Y-%m-%d %H:%M:%S)T [INFO] rclone %s is already installed... \n" $(date +%s) $latestversion | tee -a $downloadfolder/update.log >/dev/null;
fi
