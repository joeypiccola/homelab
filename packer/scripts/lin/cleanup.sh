#!/bin/bash

set -e
set -x

echo "==> Cleaning up tmp"
sudo rm -rf /tmp/*

echo "==> Cleaning up apt"
sudo apt-get -y autoremove --purge
sudo apt-get -y clean
sudo apt-get -y autoclean

echo "==> Cleaning up udev rules"
sudo rm -rf /dev/.udev/

echo "==> Blanking systemd machine-id"
if [ -f "/etc/machine-id" ]; then
    sudo truncate -s 0 "/etc/machine-id"
fi
