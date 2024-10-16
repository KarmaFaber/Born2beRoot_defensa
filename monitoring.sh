#!/bin/bash

# ARCH
arch=$(uname -a)

# CPU PHYSICAL
cpuf=$(grep "cpu cores" /proc/cpuinfo | uniq | awk '{print $4}')

# CPU VIRTUAL
cpuv=$(grep -c ^processor /proc/cpuinfo)

# RAM
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# DISK
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf ("%.1fGb\n"), disk_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} END {print disk_u}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_t+= $2} END {printf("%d"), disk_u/disk_t*100}')

# CPU LOAD
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

# LAST BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvm=$(lsblk | grep lvm | awk '{if ($1) {print "Yes";exit;} else {print "No"}}')

# TCP CONNEXIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
user=$(users | wc -w)

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO
cmndsudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "	
    	Architecture: $arch
	CPU Physical: $cpuf
	CPU Virtual: $cpuv
	Memory Usage: $uram/${fram}MB ($pram%)
	Disk Usage: $disk_use/${disk_total} ($disk_percent%)
	CPU load: $cpul%
	Last boot: $lb
	LVM use: $lvm
	Connections TCP: $tcpc ESPABLISHED
	User log: $user
	Network: IP $ip ($mac)
	Sudo: $cmndsudo cmd
    "
