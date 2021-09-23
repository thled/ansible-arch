# Ansible Arch

## Install

### Prerequisite

- [Arch Linux Installation](#arch-installation)

### Ansible Process

1. Install Git and Ansible: `$ pacman -S git ansible`
1. Install Ansible "aur" module : `$ git clone https://github.com/kewlfft/ansible-aur.git ~/.ansible/plugins/modules/aur`
1. Clone this repository: `$ git clone https://github.com/thled/ansible-arch.git`
1. Change to project directory: `$ cd ansible-arch`
1. Run the Ansible Playbook: `$ ansible-playbook playbook.yml`
1. Reboot system.
1. Login with your chosen username and start the window manager: `$ startx`

### Optional

- Add SSH keys to `~/.ssh/`.
- Sync Firefox config and addons by logging in.
- Configure bluetooth headset:
    1. `$ pulseaudio -k`
    1. `$ systemctl start bluetooth`
    1. `$ bluetoothctl`
    1. `$ default-agent`
    1. `$ scan on`
    1. `$ pair CC:98:8B:1B:7B:B1`
    1. `$ connect CC:98:8B:1B:7B:B1`
    1. `$ trust CC:98:8B:1B:7B:B1`
    1. `$ exit`

## Usage

- Start Neovim by typing `$ nvim` and wait while it initializes.
- Use the shortcut <kbd>Win</kbd>+<kbd>p</kbd> to start any application.
- Install any application by using `$ paru APP`.
- Use Arandr to configure screenlayout. Or use presets like `$ .screenlayout/xps49.sh`.

## Arch Installation

### Script (EFI)

1. Download [Arch Linux ISO][arch].
1. Verify UEFI: `$ ls /sys/firmware/efi/efivars`
1. Verify internet: `$ ping -c3 google.com`
    - If no internet: `$ iwctl`
        1. `$ device list`
        1. `$ station DEVICE scan`
        1. `$ station DEVICE get-networks`
        1. `$ station DEVICE connect SSID`
    - Still no internet: `$ dhcpcd`
1. Verify block device is `/dev/nvme0n1`: `$ fdisk -l`
1. Download script: `$ curl -LO https://raw.githubusercontent.com/thled/ansible-arch/master/arch-install.sh`
1. Execute script: `$ bash arch-install.sh`
1. Reboot, login as root and connect to wifi
    1. List wifi networks: `$ nmcli device wifi list`
    1. Connect to wifi: `$ nmcli device wifi connect SSID password PASSWORD`

### EFI

1. Download [Arch Linux ISO][arch].
1. Verify UEFI: `$ ls /sys/firmware/efi/efivars`
1. Verify internet: `$ ping -c3 google.com`
    - If no internet: `$ iwctl`
        1. `$ device list`
        1. `$ station DEVICE scan`
        1. `$ station DEVICE get-networks`
        1. `$ station DEVICE connect SSID`
    - Still no internet: `$ dhcpcd`
1. Verify block device is `/dev/sda`: `$ fdisk -l`
1. Partition disks: `$ fdisk /dev/sda`
    1. New partition layout: `$ g`
    1. New efi partition: `$ n`, <kbd>Return</kbd>, <kbd>Return</kbd>, `$ +500M`
    1. Set type of efi: `$ t`, `$ 1` ("EFI")
    1. New boot partition: `$ n`, <kbd>Return</kbd>, <kbd>Return</kbd>, `$ +500M`
    1. New root partition: `$ n`, <kbd>Return</kbd>, <kbd>Return</kbd>, <kbd>Return</kbd>
    1. Set type of root: `$ t`, <kbd>Return</kbd>, `$ 24` ("root x86_64")
    1. Write partitions: `$ w`
1. Format partitions
    1. `$ mkfs.fat -F32 /dev/sda1`
    1. `$ mkfs.ext4 /dev/sda2`
    1. `$ cryptsetup luksFormat /dev/sda3`
    1. `$ cryptsetup open /dev/sda3 cryptroot`
    1. `$ mkfs.ext4 /dev/mapper/cryptroot`
1. Mount file systems
    1. `$ mount /dev/mapper/cryptroot /mnt`
    1. `$ mkdir /mnt/boot`
    1. `$ mount /dev/sda2 /mnt/boot`
    1. `$ mkdir /mnt/boot/efi`
    1. `$ mount /dev/sda1 /mnt/boot/efi`
1. Install system: `$ pacstrap /mnt base linux linux-lts linux-firmware vim networkmanager grub efibootmgr`
1. Generate UUID for FS: `$ genfstab -U /mnt >> /mnt/etc/fstab`
1. Switch to new system: `$ arch-chroot /mnt`
1. Set root PW: `$ passwd`
1. Setup mkinitcpio
    1. Add `encrypt` in `HOOKS` before `filesystem`: `$ vim /etc/mkinitcpio.conf`
    1. Create images
        - `$ mkinitcpio -p linux`
        - `$ mkinitcpio -p linux-lts`
1. Make swap file
    1. `$ fallocate -l 2G /swapfile`
    1. `$ chmod 600 /swapfile`
    1. `$ mkswap /swapfile`
    1. `$ echo /swapfile none swap sw 0 0 >> /etc/fstab`
1. Select mirrors: `$ vim /etc/pacman.d/mirrorlist`
1. Update clock: `$ timedatectl set-ntp true`
1. Set timezone
    - `$ ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
    - `$ hwclock --systohc`
1. Add localization
    - Uncomment `en_US.UTF-8 UTF-8`: `$ vim /etc/locale.gen`
    - `$ locale-gen`
    - `$ echo LANG=en_US.UTF-8 >> /etc/locale.conf`
1. Enable NetworkManager: `$ systemctl enable NetworkManager`
1. Configure network
    - `$ echo HOSTNAME > /etc/hostname`
    - Add hosts
        - `$ echo 127.0.0.1 localhost >> /etc/hosts`
        - `$ echo ::1 localhost >> /etc/hosts`
        - `$ echo 127.0.1.1	HOSTNAME.localdomain HOSTNAME >> /etc/hosts`
1. Configure bootloader
    1. Edit `$ vim /etc/default/grub`
        - Add to `GRUB_CMDLINE_LINUX_DEFAULT` before `quiet`: `cryptdevice=/dev/sda3:cryptroot:allow-discards`
        - Uncomment `GRUB_ENABLE_CRYPTODISK`
    1. `$ grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --recheck`
    1. `$ grub-mkconfig -o /boot/grub/grub.cfg`
1. Reboot system
    1. `$ exit`
    1. `$ umount -R /mnt`
    1. `$ shutdown`
1. Login as root and connect to wifi
    1. List wifi networks: `$ nmcli device wifi list`
    1. Connect to wifi: `$ nmcli device wifi connect SSID password PASSWORD`

### BIOS

1. Verify internet: `$ ping -c3 google.com`
    - If no internet: `$ iwctl`
        1. `$ device list`
        1. `$ station DEVICE scan`
        1. `$ station DEVICE get-networks`
        1. `$ station DEVICE connect SSID`
    - Still no internet: `$ dhcpcd`
1. Verify block device is `/dev/sda`: `$ fdisk -l`
1. Partition disks: `$ fdisk /dev/sda`
    1. New partition layout: `$ o`
    1. New boot partition: `$ n`, <kbd>Return</kbd>, <kbd>Return</kbd>, `$ +500M`
    1. New root partition: `$ n`, <kbd>Return</kbd>, <kbd>Return</kbd>, <kbd>Return</kbd>
    1. Write partitions: `$ w`
1. Format partitions
    1. `$ mkfs.ext4 /dev/sda1`
    1. `$ cryptsetup luksFormat /dev/sda2`
    1. `$ cryptsetup open /dev/sda2 cryptroot`
    1. `$ mkfs.ext4 /dev/mapper/cryptroot`
1. Mount file systems
    1. `$ mount /dev/mapper/cryptroot /mnt`
    1. `$ mkdir /mnt/boot`
    1. `$ mount /dev/sda1 /mnt/boot`
1. Install system: `$ pacstrap /mnt base linux linux-lts linux-firmware vim networkmanager grub efibootmgr`
1. Generate UUID for FS: `$ genfstab -U /mnt >> /mnt/etc/fstab`
1. Switch to new system: `$ arch-chroot /mnt`
1. Set root PW: `$ passwd`
1. Setup mkinitcpio
    1. Add `encrypt` in `HOOKS` before `filesystem`: `$ vim /etc/mkinitcpio.conf`
    1. Create images
        - `$ mkinitcpio -p linux`
        - `$ mkinitcpio -p linux-lts`
1. Make swap file
    1. `$ fallocate -l 2G /swapfile`
    1. `$ chmod 600 /swapfile`
    1. `$ mkswap /swapfile`
    1. `$ echo /swapfile none swap sw 0 0 >> /etc/fstab`
1. Select mirrors: `$ vim /etc/pacman.d/mirrorlist`
1. Update clock: `$ timedatectl set-ntp true`
1. Set timezone
    - `$ ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
    - `$ hwclock --systohc`
1. Add localization
    - Uncomment `en_US.UTF-8 UTF-8`: `$ vim /etc/locale.gen`
    - `$ locale-gen`
    - `$ echo LANG=en_US.UTF-8 >> /etc/locale.conf`
1. Enable NetworkManager: `$ systemctl enable NetworkManager`
1. Configure network
    - `$ echo HOSTNAME > /etc/hostname`
    - Add hosts
        - `$ echo 127.0.0.1 localhost >> /etc/hosts`
        - `$ echo ::1 localhost >> /etc/hosts`
        - `$ echo 127.0.1.1	HOSTNAME.localdomain HOSTNAME >> /etc/hosts`
1. Configure bootloader
    1. Edit `$ vim /etc/default/grub`
        - Add to `GRUB_CMDLINE_LINUX_DEFAULT` before `quiet`: `cryptdevice=/dev/sda2:cryptroot:allow-discards`
        - Uncomment `GRUB_ENABLE_CRYPTODISK`
    1. `$ grub-install /dev/sda`
    1. `$ grub-mkconfig -o /boot/grub/grub.cfg`
1. Reboot system
    1. `$ exit`
    1. `$ umount -R /mnt`
    1. `$ shutdown`
1. Login as root and connect to wifi
    1. List wifi networks: `$ nmcli device wifi list`
    1. Connect to wifi: `$ nmcli device wifi connect SSID password PASSWORD`

[arch]: https://www.archlinux.org/download/
