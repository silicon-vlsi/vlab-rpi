# VLSI Lab on Raspberry Pi 500+


# IIC-OSIC Tools Installation

Instructions are for install and setup of Ubuntu 24.04 desktop Raspberry Pi 500+.

- **CREATE UBUNTU 24.04 DESKTOP USB/SDC BOOT DEVICE**
  - Using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) create a bootable USB for a full Raspbian OS (or other distro).
- **INSTALL ON BOOT SDC/USB (ONE TIME)**
  - &#128073; Boot the SDC/USB from RasPi500+ (by pressing Space Bar repeatedly till you get the boot menu.)
  - The first boot will install the distro on the device itself usb/sdc.
  - Update the distro.
  - Download the `ubuntu-24.04.3-preinstalled-desktop-arm64+raspi.img.xz` from https://ubuntu.com/download/raspberry-pi
- **POST BOOT SDC/USB**
  - Write the image to the RasPi NVMe SSD:
    - &#128073; `sudo rpi-imager --cli ubuntu-24.04.3-preinstalled-desktop-arm64+raspi.img.xz /dev/nvme0n1`
      - Do a `lsblk` to find the NVMe device name.
  - After successful write, remove the sdc/usb and boot from the NVMe SSD and isntall Ubuntu 
- **POST INSTALLATION**
  - Login as admin (user: `ubuntu`)
  - &#128073; DISABLE the auto siftware update when it pops up.
  - &#128073; **COPY** `iic-osic-tools.tar` from the USB stick to the location `/opt`
    - To find the mount location, use the command `lsblk`
  - &#128073; Install git: `sudo apt install git -y`
  - &#128073; `mkdir gits; cd gits`
  - &#128073; Clone the this repo: `git clone https://github.com/silicon-vlsi/vlab-rpi`
  - &#128073; Update distro: `$HOME/gits/vlap-rpi/bin/post-install.sh update`
  - &#128073; REBOOT
  - Unpin some unecessary Apps from the dash: Rythmbox, etc.
  - &#128073; Install some essentials (vim, chromium, etc): `$HOME/gits/vlap-rpi/bin/post-install.sh pkg1`
  - **Docker Installation**
    - Check `https://docs.docker.com/engine/install/ubuntu`
    - &#128073;  Setup the apt repo for docker: `$HOME/gits/bin/post-install.sh apt-docker` 
    - &#128073; Install docker: `$HOME/gits/vlap-rpi/bin/post-install.sh pkg-docker`
      - **NOTE** When using `apt`, got into 404 download error. So downloaded the packages (.deb) from the [docker download](https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/arm64/) and put it in this repo and isntalled it using `dpkg`. So will need to do manual update.
    - Check if _active_: `sudo systemctl status docker`
    - Ref: `https://docs.docker.com/engine/install/linux-postinstall`
    - Add users to docker (This will be done automatically for the users created in batch): `sudo usermod -aG docker $USER`
  - &#128073; Setup **IIC-OSIC-TOOLS** by executing: `$HOME/gits/vlap-rpi/bin/post-install.sh setup-osic`
  - &#128073; Create `/usr/local/bin/start-ic.sh`: `$HOME/gits/vlap-rpi/bin/post-install start-ic`
  - &#128073; **User creation** (currently 50): `sudo $HOME/gits/vlap-rpi/bin/post-install.sh create-users`
    - The script will add cutomizations to `/etc/skel/.bashrc` create users, add the users to `docker` and `users` group. After the users are created, the persistent folders `$HOME/eda/designs`. 

- **STARTING IIC OSIC TOOLS**
  - After login, the user can start the docker: `start-ic.sh`
  - The docker shell will start with `/foss/designs` folder which is mapped to `$HOME/eda/designs`. Create all persistent work area here. 
  - The default PDK is IHP, to change to SKY130A, execute `sak-pdk sky130A`

     
## Installing IIC-OSIC-tools from a local tarball

Here's the recipe for 2025.12 (You can find the version in the docker repo: `hpretl/iic-osic-tools`) :

**Creating a tarball of the docker image**

**NOTE** The user needs to be in the group `docker` to run it in user mode.

- `docker pull hpretl/iic-osic-tools:2025.12`
- `docker save -o iic-osic-tools.tar hpretl/iic-osic-tools:2025.12`
- Make the tarball `iic-osic-tools.tar` available on the target machine.

**Install the Docker image from the tarball on the target maching**:

- `docker load -i iic-osic-tools.tar`

**To fix the version**, add the following in `~/.bashrc`

- `export DOCKER_TAG=2025.12`

Now the startup should be a matter of seconds:  `./start_x.sh`


