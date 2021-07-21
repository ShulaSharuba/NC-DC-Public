#!/bin/sh

# Add a new user
adduser -s /bin/ash -G users marc

# Include root home and user marc folder as working directory + /usr for netdata
lbu include /root
lbu include /home/marc
lbu include /usr

# Install sudo
apk add sudo

# Edit sudo file
echo Uncomment from sudo file:
echo "%wheel ALL=(ALL) ALL"
read -p "press any key to continue..."
visudo

# Edit /etc/apk/repositories
echo Edit /etc/apk/repositories and uncomment:
echo "http://mirrors.2f30.org/alpine/v#.#/community"
echo "http://mirrors.2f30.org/alpine/edge/testing"
read -p "press any key to continue..."
vi /etc/apk/repositories

# Edit /etc/group
echo Edit /etc/group and add marc to the wheel group
echo "wheel:x:10:root,marc"
read -p "press any key to continue..."
vi /etc/group

# Edit /etc/ssh/sshd_config
echo Edit /etc/ssh/sshd_config and uncomment/change:
echo "Port 22"
echo "PermitRootLogin no"
read -p "press any key to continue..."
vi /etc/ssh/sshd_config

# Install docker
apk add docker
rc-update add docker boot
service docker start

# Install other useful packages
apk add git
apk add docker-compose
apk add findmnt
apk add ncdu

# Install packages required for Netdata
apk add alpine-sdk bash curl libuv-dev zlib-dev util-linux-dev libmnl-dev gcc make git autoconf automake pkgconfig logrotate

# Clone Netdata git repo
git clone https://github.com/netdata/netdata.git --depth=100 /root/netdata

# Build Netdata
echo "Nedata needs to be installed manually. CD into /root/netdata/ and run ./netdata-installer.sh"
read -p "press any key to continue..."

# Done!
