#!/bin/bash

# ARCH
arch=$(uname -a)

# CPU PHYSICAL
cpuf=$(grep -m1 "cpu cores" /proc/cpuinfo | awk '{print $4}')

# CPU VIRTUAL
cpuv=$(grep -c ^processor /proc/cpuinfo)

# RAM
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free -m | awk '$1 == "Mem:" {printf("%.2f", $3/$2*100)}')

# DISK
fdisc=$(df -h --total | awk '/^total/ {print $2}')
udisc=$(df -h --total | awk '/^total/ {print $3}')
pdisc=$(df -h --total | awk '/^total/ {print $5}')

# CPU LOAD
cpul=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1)

# LAST BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvm=$(lsblk | grep -q lvm && echo "Yes" || echo "No")

# TCP CONNECTIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
user=$(users | wc -w)

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO
cmndsudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

# Display the system information
wall "
	Architecture: $arch
	CPU Physical: $cpuf
	CPU Virtual: $cpuv
	Memory Usage: $uram/${fram}MB ($pram%)
	Disk Usage: $udisc/${fdisc} ($pdisc)
	CPU Load: $cpul
	Last boot: $lb
	LVM use: $lvm
	Connections TCP: $tcpc ESTABLISHED
	User log: $user
	Network: IP $ip ($mac)
	Sudo: $cmndsudo cmd
"
