# vlab-rpi
VLSI Lab on Raspberry Pi


# Installation

Instructions are for install and setup of Ubuntu 24.04.3 LTS Server plus XFCE with Light  DM on Raspberry Pi 500+ .

- **CREATE RASPBIAN USB BOOT DEVICE**
  - Using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) create a bootable USB for a full Raspbian OS (or other distro).
- **BOOT RASPBIAN**
  - Boot the USB from RasPi500+ (by pressing Space Bar repeatedly till you get the boot menu.)
  - Update the distro.
  - Download the `ubuntu-24.04.3-preinstalled-desktop-arm64+raspi.img.xz` from https://ubuntu.com/download/raspberry-pi
  - From the application menu, start **Raspberry Pi Imager" :
    - Device: Rasberry Pi 5
    - OS: Custom  (Select the image file `ubuntu-24.04.3-preinstalled-desktop-arm64+raspi.img.xz`)
    - Storage: You should see the SSD something as `XP1000F256G (system-boot, writable)`
    - Customization: (Not allowed for custom image)
    - Writing: Write it !
