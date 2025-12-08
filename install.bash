#!/bin/bash

echo "1. Configuring the disk"

echo "Available disks:"
lsblk | grep disk

read -p "Choose disk id for install OS:" diskid

sed 's/<DISKID>/'"$diskid"'/g' ./disko/disk-config-normal.nix > disk-config.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disk-config.nix

echo "2. Configuring NixOS"

nixos-generate-config --root /mnt

cp configuration.nix /mnt/etc/nixos/

sleep 5

nixos-install

nixos-enter --root /mnt -c 'passwd aiteron'

read -p "Reboot system? (yes/no)" answer
if [[ "${answer,,}" == "yes" ]]; then
    reboot
fi
