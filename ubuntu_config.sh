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

# Disable sleep
read -p "Disable sleep mode"

systemctl mask sleep.target suspend.target hybrid-sleep.target hibernate.target


# Create a new partition for CHIA Temp

read -p "Create a new partition"
# echo "/dev/nvme0n1p5 : start=    88057856, size=   912157327, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4" > sudo sfdisk /dev/nvme0
# sfdisk /dev/nvme0n1

(
echo n # Add a new partition
echo 5 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/nvme0n1



read -p "Create Logical volume"


sudo vgcreate plotvg /dev/nvme0n1p5
sudo lvcreate -n tmpdir -l 100%FREE plotvg
sudo mkfs.xfs /dev/plotvg/tmpdir
sudo mkdir -p /chia/tmpdir
sudo mkdir -p /chia/tmpdir2


# sudo mount //dev/plotvg/tmpdir /chia/tmpdir
echo "/dev/plotvg/tmpdir    /chia/tmpdir   xfs" >> /dev/fstab

#sudo mount -t tmpfs -o size=110G tmpfs /mnt/ram/
# tmpfs       /mnt/ramdisk tmpfs   nodev,nosuid,noexec,nodiratime,size=1024M   0 0
echo "tmpfs       /chia/tmpdir2 tmpfs   size=110G" >> /etc/fstab
mount -a



#### Install MAD Max CHIA Plotter
mkdir chia-plotter
apt install -y libsodium-dev cmake g++ git build-essential
# Checkout the source and install
git clone https://github.com/madMAx43v3r/chia-plotter.git 
cd chia-plotter

git submodule update --init
./make_devel.sh
./build/chia_plot --help



###############################
# Some fine tunning
###############################

##### Remove snap
# First snaps

read -p "Create Logical volume"

 snap remove --purge lxd
 snap remove --purge core18
 snap remove --purge core20
 snap remove --purge snapd

# Clear snap Cache

 rm -rf /var/cache/snapd/
 apt autoremove --purge snapd gnome-software-plugin-snap
 rm -fr ~/snap


# Stop snap service

apt-mark hold snapd






# Finish

read -p "System should be rebooted"
reboot



#################### Add disk subsystem

# Configure iSCSI
# Add LUN
# Check FS








