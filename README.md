# Ansible Arch

## Usage

0. Install [Arch Linux](#arch-installation).
0. Install Git and Ansible: `$ pacman -S git ansible`
0. Install Ansible "aur" module : `$ git clone https://github.com/kewlfft/ansible-aur.git ~/.ansible/plugins/modules/aur`
0. Clone this repository: `$ git clone https://github.com/thled/ansible-arch.git`
0. Change to project directory: `$ cd ansible-arch`
0. Run the Ansible Playbook: `$ ansible-playbook playbook.yml`
0. Set user password: `$ passwd XXX` (`XXX` = username)
0. Reboot system.
0. Login with your chosen username and start i3: `$ startx`

## Optional

- Add SSH keys to `~/.ssh/`.
- Sync Firefox config and addons by logging in.

## Arch Installation

0. Download [Arch Linux ISO][arch].
0. Verify internet: `$ ping google.com`
0. Update clock: `$ timedatectl set-ntp true`
0. Partition disks: `$ cfdisk`
    - Main bootable: available disc space - 2G; make bootable
    - Swap: 2G; type Swap
0. Format partitions
    - `$ mkfs.ext4 /dev/sda1`
    - `$ mkswap /dev/sda2`
    - `$ swapon /dev/sda2`
0. Mount file system: `$ mount /dev/sda1 /mnt`
0. Select mirrors: `$ vim /etc/pacman.d/mirrorlist`
0. Install packages: `$ pacstrap /mnt base linux linux-firmware dhcpcd grub vim`
0. Generate UUID for FS: `$ genfstab -U /mnt >> /mnt/etc/fstab`
0. CD into new system: `$ arch-chroot /mnt`
0. Set timezone
    - `$ ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
    - `$ hwclock --systohc`
0. Add localization
    - Uncomment `en_US.UTF-8 UTF-8`: `$ vim /etc/locale.gen`
    - `$ locale-gen`
    - Set `LANG=en_US.UTF-8`: `$ vim /etc/locale.conf`
0. Configure network
    - Add `thledpc`: `$ vim /etc/hostname`
    - Add following hosts: `$ vim /etc/hosts`
        ```shell
        127.0.0.1	localhost
        ::1		localhost
        127.0.1.1	thledpc.localdomain	thledpc
        ```
0. Set root PW: `$ passwd`
0. Configure bootloader
    - `$ grub-install /dev/sda`
    - `$ grub-mkconfig -o /boot/grub/grub.cfg`
0. Reboot system.

[arch]: https://www.archlinux.org/download/
