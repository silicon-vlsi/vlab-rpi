# VLSI Lab on Raspberry Pi 500+


# Installation

Instructions are for install and setup of Ubuntu 24.04 desktop Raspberry Pi 500+.

- **CREATE UBUNTU 24.04 DESKTOP USB/SDC BOOT DEVICE**
  - Using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) create a bootable USB for a full Raspbian OS (or other distro).
- **BOOT SDC/USB**
  - Boot the SDC/USB from RasPi500+ (by pressing Space Bar repeatedly till you get the boot menu.)
  - The first boot will install the distro on the device itself usb/sdc.
  - Update the distro.
  - Download the `ubuntu-24.04.3-preinstalled-desktop-arm64+raspi.img.xz` from https://ubuntu.com/download/raspberry-pi
  - Write the image to the RasPi NVMe SSD:
    - `sudo rpi-imager --cli ubuntu-24.04.3-preinstalled-desktop-arm64+raspi.img.xz /dev/nvme0n1`
      - Do a `lsblk` to find the NVMe device name.
  - After successful write, remove the sdc/usb and boot from the NVMe SSD and isntall Ubuntu 
- **POST INSTALLATION**
  - Login as admin (user: `ubuntu`)
  - Install git: `sudo apt install git -y`
  - `mkdir gits; cd gits`
  - Clone the this repo: `git clone https://github.com/silicon-vlsi/vlab-rpi.git`
  - Update distro: `$HOME/gits/vlap-rpi/bin/post-install.sh update`
  - REBOOT
  - Unpin some unecessary Apps from the dash: Rythmbox, etc.
  - Install some essentials (vim, chromium, etc): `$HOME/gits/vlap-rpi/bin/post-install.sh pkg1`
  - **Docker Installation**
    - Check `https://docs.docker.com/engine/install/ubuntu`
    -  Setup the apt repo for docker: `$HOME/gits/bin/docker-apt-setup.sh` 
    - Install docker: `$HOME/gits/vlap-rpi/bin/post-install.sh pkg-docker`
      - **NOTE** When using `apt`, got into 404 download error. So downloaded the packages (.deb) from the [docker download](https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/arm64/) and put it in this repo and isntalled it using `dpkg`. So will need to do manual update.
    - Check if _active_: `sudo systemctl status docker`
    - Ref: `https://docs.docker.com/engine/install/linux-postinstall`
    - Add users to docker: `sudo usermod -aG docker $USER`
  - Setup **IIC-OSIC-TOOLS** by executing: `$HOME/gits/vlap-rpi/bin/setup-osic.sh`
  - Copy the `start-ic.sh` script to `/usr/local/bin`:
    - `sudo cp $HOME/gits/vlap-rpi/bin/start-ic.sh /usr/local/bin/.`
  - **User creation** (currently 50): execute: `$HOME/gits/vlap-rpi/bin/create_users.sh`
    - The script will create users, add the users to docker and users group. After the users are created, the persistent folders for IIC-OSIC-TOOLS will be created with appropriate permissions.

- **STARTING IIC OSIC TOOLS**
  - After login, the user can start the docker: `start-ic.sh`
  - The docker shell will start with `/foss/designs` folder which is mapped to `$HOME/eda/designs`. Create all persistent work area here. 
  - The default PDK is IHP, to change to SKY130A, execute `sak-pdk sky130A`

     
