#!/bin/bash
# creating RAID50 on empty disks
# creating gpt labels for the first raid 5
parted -a optimal -s /dev/sdb mklabel gpt
parted -a optimal -s /dev/sdc mklabel gpt
parted -a optimal -s /dev/sdd mklabel gpt
# creating gpt labels for the second raid 5
parted -a optimal -s /dev/sde mklabel gpt
parted -a optimal -s /dev/sdf mklabel gpt
parted -a optimal -s /dev/sdg mklabel gpt
# killing partitions on disks
dd if=/dev/zero bs=512 count=1 of=/dev/sdb
dd if=/dev/zero bs=512 count=1 of=/dev/sdc
dd if=/dev/zero bs=512 count=1 of=/dev/sdd
dd if=/dev/zero bs=512 count=1 of=/dev/sde
dd if=/dev/zero bs=512 count=1 of=/dev/sdf
dd if=/dev/zero bs=512 count=1 of=/dev/sdg
# creating RAID5 arrays
mdadm --create /dev/md0 -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd
mdadm --create /dev/md1 -l 5 -n 3 /dev/sde /dev/sdf /dev/sdg
# creating RAID0 over RAID5 arrays
mdadm --create /dev/md2 -l 0 -n 2 /dev/md0 /dev/md1
# add fs to RAID50
mkfs.ext4 /dev/md2
# creating config
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
echo "$(blkid | grep /dev/md2 | awk '{print $2}') /mnt ext4 defaults 0 0" >> /etc/fstab
mount /mnt
#
