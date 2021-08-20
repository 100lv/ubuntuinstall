# Bash script
# This script prepares CHIA Plotter system
# Version 1.0
# 20 August 2021
# Svetoslav Tolev

read -p "Starting configuration. Each and evey command now requests pressing ENTER to continue"

read -p "Starting system update"


# Next few linex upgrade systm to latest level
apt update
apt upgrade -y


read -p "Now we will upgrade the kernel to fix the isssues with Intel adapter"


# Download kernel files

wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.12.19/amd64/linux-headers-5.12.19-051219-generic_5.12.19-051219.202107201136_amd64.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.12.19/amd64/linux-headers-5.12.19-051219_5.12.19-051219.202107201136_all.deb
wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.12.19/amd64/linux-image-unsigned-5.12.19-051219-generic_5.12.19-051219.202107201136_amd64.deb
wget  https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.12.19/amd64/linux-modules-5.12.19-051219-generic_5.12.19-051219.202107201136_amd64.deb

# Start install

sudo dpkg -i *.deb


# Remove kernel files

rm linux-headers-5.12.19-051219-generic_5.12.19-051219.202107201136_amd64.deb
rm linux-headers-5.12.19-051219_5.12.19-051219.202107201136_all.deb
rm linux-image-unsigned-5.12.19-051219-generic_5.12.19-051219.202107201136_amd64.deb
rm linux-modules-5.12.19-051219-generic_5.12.19-051219.202107201136_amd64.deb



# Create a new partition for CHIA Temp

read -p "Create a new partition"
echo "/dev/nvme0n1p5 : start=    88057856, size=   912157327, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4" > sudo sfdisk /dev/nvme0
sfdisk /dev/nvme0n1

read -p "Create Logical volume"


sudo vgcreate plotvg /dev/nvme0n1p5
sudo lvcreate -n tmpdir -l 100%FREE plotvg
sudo mkfs.xfs /dev/plotvg/tmpdir
sudo mkdir -p /chia/tmpdir
sudo mount //dev/plotvg/tmpdir /chia/tmpdir


