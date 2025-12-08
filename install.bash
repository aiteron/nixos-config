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
cp home.nix /mnt/etc/nixos/
cp flake.nix /mnt/etc/nixos/

nixos-install --flake /mnt/etc/nixos#nixos-btw

## type your password
nixos-enter --root /mnt -c 'passwd tony'
reboot

