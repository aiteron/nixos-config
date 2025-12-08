#!/bin/bash

echo "1. Configuring the disk"

echo "Available disks:"
lsblk | grep disk

read -p "Choose disk id for install OS:" diskid

sed 's/<DISKID>/'"$diskid"'/g' ./disko/disk-config-normal.nix > disk-config.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disk-config.nix

