#!/bin/bash
# creating RAID50 on empty disks
# creating RAID5 arrays
mdadm --create /dev/md0 -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd
mdadm --create /dev/md1 -l 5 -n 3 /dev/sde /dev/sdf /dev/sdg
# creating RAID0 over RAID5 arrays
mdadm --create /dev/md2 -l 0 -n 2 /dev/md0 /dev/md1
# creating config 
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
# creating gpt label and adding partitions
parted -a optimal -s /dev/md2 mklabel gpt mkpart test1 ext4 0% 10% mkpart test2 ext4 10% 20% mkpart test3 ext4 20% 30% mkpart test4 ext4 30% 40% mkpart test5 ext4 40% 100%
# formatting partitions 
mkfs.ext4 /dev/md2p1
mkfs.ext4 /dev/md2p2
mkfs.ext4 /dev/md2p3
mkfs.ext4 /dev/md2p4
mkfs.ext4 /dev/md2p5
# adding mount points
mkdir /mnt/test{1,2,3,4,5}
echo "$(blkid | grep /dev/md2p1 | awk '{print $2}') /mnt/test1 ext4 defaults 0 0" >> /etc/fstab
echo "$(blkid | grep /dev/md2p2 | awk '{print $2}') /mnt/test2 ext4 defaults 0 0" >> /etc/fstab
echo "$(blkid | grep /dev/md2p3 | awk '{print $2}') /mnt/test3 ext4 defaults 0 0" >> /etc/fstab
echo "$(blkid | grep /dev/md2p4 | awk '{print $2}') /mnt/test4 ext4 defaults 0 0" >> /etc/fstab
echo "$(blkid | grep /dev/md2p5 | awk '{print $2}') /mnt/test5 ext4 defaults 0 0" >> /etc/fstab
mount /mnt/test1
mount /mnt/test2
mount /mnt/test3
mount /mnt/test4
mount /mnt/test5