# rclone-updater
Update script for rclone package for Debian/Ubuntu and RHEL/Fedora

rclone-updater-deb.sh = Debian/Ubuntu

rclone-updater-rpm.sh = RHEL/Fedora

Fetches latest version from rclone.org and compares version to currently installed version, will only download/install update if latest version is newer then currently installed version.

Update downloadfolder="/change/me/example/directory" to the directory where you want packages temp stored and log files stored.

Run with sudo.

Cheers!
