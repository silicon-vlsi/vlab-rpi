#!/bin/sh
# DO NOT USE, integrated into post_install..
cd /opt
sudo git clone --depth 1 https://github.com/iic-jku/IIC-OSIC-TOOLS.git
sudo chown -R root:users IIC-OSIC-TOOLS
sudo chmod 775 IIC-OSIC-TOOLS
