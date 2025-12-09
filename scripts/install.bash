#!/bin/bash

echo "1. Configuring the disk"
cp $(dirname "$0")/../nix/installation/disko-config.nix .

echo "Available disks:"
lsblk | grep disk
read -p "Choose disk id for install OS: " diskid

sed 's/<DISKID>/'"$diskid"'/g' disko-config.nix > disko-config.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix

echo "2. Configuring basic NixOS config"
nixos-generate-config --root /mnt
cp $(dirname "$0")/../nix/installation/configuration.nix .

read -p "Enter the hostname (name of device in network) : " hostname
sed 's/<TTT>/'"$hostname"'/g' configuration.nix > configuration.nix

read -p "Enter the username : " username
sed 's/<USERNAME>/'"$username"'/g' configuration.nix > configuration.nix

read -p "Enter the timezone (leave blank for default ('America/New_York')) : " timezone
sed 's/<TIMEZONE>/'"$timezone"'/g' configuration.nix > configuration.nix

state_version=$(grep "stateVersion" /mnt/etc/nixos/configuration.nix | cut -d'=' -f2 | tr -d ' ";')
sed 's/<STATEVERSION>/'"$state_version"'/g' configuration.nix > configuration.nix

cp configuration.nix /mnt/etc/nixos/

sleep 5

nixos-install

echo "Enter password for "$username
nixos-enter --root /mnt -c 'passwd '"$username"

read -p "Reboot system? (yes/no) " answer
if [[ "${answer,,}" == "yes" ]]; then
    reboot
fi
