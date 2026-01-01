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

- **POST INSTALLATION**
  - Update distro
  - Install some essentials: `vim, htop, tree, chromium`
  - Prepare `IIC-OSIC-TOOLS` location
    - `cd /opt`
    - `sudo git clone --depth 1 https://github.com/iic-jku/IIC-OSIC-TOOLS.git`
    - `chown -R root:users IIC-OSC-TOOLS`
    - `chmod 755 IIC-OSIC-TOOLS`
  - **Docker Installation**
    - `https://docs.docker.com/engine/install/ubuntu`
    - There is apt repo script in the above location, copy and run it.
    - Install docker: `sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`
    - Check: `sudo systemctl status docker`
    - Ref: `https://docs.docker.com/engine/install/linux-postinstall`
    - Add users to docker: `sudo usermod -aG docker $USER`
    - Create `/usr/local/bin`:

```bash
cd /opt/IIC-OSIC-TOOLS
export DESIGNS=$HOME/eda/designs
./start_x.sh
```

     - When user runs the script, the OSIC tool terminal should popup.
     - change PDK: `sak-pdk sky130A`
     
