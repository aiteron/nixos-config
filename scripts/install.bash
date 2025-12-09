#!/bin/bash

echo "1. Configuring the disk"
disko_config=$(cat $(dirname "$0")/../nix/installation/disko-config.nix)

echo "Available disks:"
lsblk | grep disk
read -p "Choose disk id for install OS: " diskid

echo "$disko_config" | sed 's/<DISKID>/'"$diskid"'/g' > disko-config.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disko-config.nix

echo "2. Configuring basic NixOS config"
nixos-generate-config --root /mnt
configuration=$(cat $(dirname "$0")/../nix/installation/configuration.nix)

read -p "Enter the hostname (name of device in network) : " hostname
configuration=$(echo "$configuration" | sed 's/<HOSTNAME>/'"$hostname"'/g')

read -p "Enter the username : " username
configuration=$(echo "$configuration" | sed 's/<USERNAME>/'"$username"'/g')

read -p "Enter the timezone (leave blank for default ('America/New_York')) : " timezone
if [ -z "$timezone" ]; then
    timezone="America/New_York"
fi
configuration=$(echo "$configuration" | sed 's@<TIMEZONE>@'"$timezone"'@g')

state_version=$(grep "system.stateVersion = " /mnt/etc/nixos/configuration.nix | cut -d'=' -f2 | sed 's/#.*$//' | tr -d ' ";')
echo "$configuration" | sed 's/<STATEVERSION>/'"$state_version"'/g' > configuration.nix

cp configuration.nix /mnt/etc/nixos/

nixos-install

echo "Enter password for ""$username"
nixos-enter --root /mnt -c 'passwd '"$username"

read -p "Reboot system? (yes/no) " answer
if [[ "${answer,,}" == "yes" ]]; then
    reboot
fi
