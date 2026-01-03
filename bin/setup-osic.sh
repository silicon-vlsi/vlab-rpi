#!/bin/sh
#
cd /opt
sudo git clone --depth 1 https://github.com/iic-jku/IIC-OSIC-TOOLS.git
sudo chown -R root:users IIC-OSC-TOOLS
sudo chmod 775 IIC-OSIC-TOOLS
