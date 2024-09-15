#!/bin/bash

# This script ONLY works on those Linux brands that use apt packagemanager,
# such as Debian and those Debian-based ones, for example Ubuntu, Deepin, and MX Linux etc.


if [ "$EUID" -ne 0 ] ; then
  echo "Please run as root"
  exit 1
fi

echo ============================
echo sudo apt update
     sudo apt update

echo ============================
echo sudo apt upgrade -y
     sudo apt upgrade -y

echo ============================
echo sudo apt dist-upgrade -y
     sudo apt dist-upgrade -y

echo ============================
echo sudo apt autoremove -y
     sudo apt autoremove -y

echo ============================
echo sudo apt autoclean -y
     sudo apt autoclean -y

