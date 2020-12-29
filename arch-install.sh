#!/bin/bash

set -e

function log {
  local LINE="[arch-install] $*"
  echo "$LINE"
  echo "${LINE//?/-}"
}

function ask {
  read -p "$1> "
  eval "export $2=\$REPLY"
}

log "Setup questions:"
ask 'Encryption password' __ENCRYPTION__
ask 'Root password' __PASSWORD__
ask 'Hostname' __HOSTNAME__

log "Checking network reachability"
ping -c 3 google.com

log "Setting up NTP"
timedatectl set-ntp true

log "Updating mirror list"
reflector -c Germany,France,Spain -a 6 --sort rate --save /etc/pacman.d/mirrorlist

log "Refreshing packages"
pacman -Syy

log "Partitioning disk"
cat << HERE | sfdisk /dev/nvme0n1
label: gpt
device: /dev/nvme0n1

/dev/nvme0n1p1: size=500MiB, type=uefi
/dev/nvme0n1p2: type=linux
HERE

log "Formatting /boot"
mkfs.fat -F32 /dev/nvme0n1p1

log "Formatting /"
echo -n "${__ENCRYPTION__}" | cryptsetup luksFormat /dev/nvme0n1p2 -
echo -n "${__ENCRYPTION__}" | cryptsetup open /dev/nvme0n1p2 cryptroot --key-file -
mkfs.ext4 /dev/mapper/cryptroot

log "Mounting /dev/nvme0n1p2 at /"
mount /dev/mapper/cryptroot /mnt

log "Mounting /dev/nvme0n1p1 at /boot"
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

log "Creating /etc/fstab"
mkdir /mnt/etc
genfstab -U -p /mnt >> /mnt/etc/fstab

log "Installing base packages"
pacstrap /mnt base base-devel

cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/

cat << HERE > /mnt/arch-install-chroot.sh
set -e

function log {
  local LINE="[arch-linux-install] \$*"
  echo "\$LINE"
  echo "\${LINE//?/-}"
}

log "Set root password"
echo "root:\$__PASSWORD__" | chpasswd

log "Installing kernel"
pacman -S --noconfirm linux-lts linux-lts-headers linux-firmware

log "Preparing ramdisks for kernel boot"
sed -i 's/^HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -p linux-lts

log "Setting up swap"
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo -e '\n/swapfile none swap sw 0 0' >> /etc/fstab

log "Set timezone"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

log "Setting up locale"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

log "Setting up boot"
pacman -S --noconfirm grub efibootmgr
UUID=\$(lsblk /dev/nvme0n1p2 -o UUID -d -n)
sed -i "s/^GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=\${UUID}:cryptroot root=\/dev\/mapper\/cryptroot\"/" /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

log "Setting up network"
echo "\$__HOSTNAME__" > /etc/hostname
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

exit
HERE

log "Entering chroot env"
arch-chroot /mnt /bin/bash arch-install-chroot.sh

log "Finished"
rm /mnt/arch-install-chroot.sh
set +e
umount -a

