#!/bin/bash
#
if [ $# -ne 1 ]
then 
  echo " "
  echo "Usage: $0 <options>"
  echo " "
  echo "DESCRIPTION: Options are "
  echo "  update:	Update the distro"
  echo "  pkg1:		Essentail pkgs (vim, chromium, etc)"
  echo "  setup-osic:   Setup /opt/IIC-OSIC-TOOLS with right perms"	
  echo "  pkg-docker:	Docker pkgs "
  echo "  append-skel:	Append /etc/skel/.bashrc "
  echo " "
  exit 1
fi

if [ $1 == "update" ]
then
  echo "########################"
  echo "# UPDATING DISTRO "
  echo "########################"
  sudo apt update -y && sudo apt upgrade -y
fi

if [ $1 == "setup-osic" ]
then
  echo "########################"
  echo "# SETTING /opt/IIC-OSIC-TOOLS "
  echo "########################"
  cd /opt
  sudo git clone --depth 1 https://github.com/iic-jku/IIC-OSIC-TOOLS.git
  sudo chown -R root:users IIC-OSIC-TOOLS
  sudo chmod 775 IIC-OSIC-TOOLS
fi

if [ $1 == "append-skel" ]
then
  echo "########################"
  echo "# APPEND /etc/skel/.bashrc"
  echo "########################"
  sudo tee -a /etc/skel/.bashrc <<EOF

#CUSTOMIZATION
alias date='date +%D'
alias h='history'
alias vimr='vim -R'
alias rm='rm -i'
alias du10='du -BM -s * .[^.]* | sort -n | tail -10'
EOF

fi

if [ $1 == "pkg1" ]
then
  echo "########################"
  echo "# INSTALLING ESSENTIAL PKG1 "
  echo "########################"
  pkg1arr=( \
	 vim tree htop \
	 )
 for i in ${pkg1arr[*]}
   do
     sudo apt install $i -y
   done 
fi

if [ $1 == "pkg-docker" ]
then
  echo "########################"
  echo "# INSTALLING DOCKER PKGs "
  echo "########################"
  #  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
  # Had errors while using apt install so downloaded the packages from
  # https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/arm64/
  # Stick to the order.. 
  pkg_docker_arr=( \
    containerd.io_2.2.0-2~ubuntu.24.04~noble_arm64.deb \
    docker-ce-cli_29.1.3-1~ubuntu.24.04~noble_arm64.deb \
    docker-ce_29.1.3-1~ubuntu.24.04~noble_arm64.deb \
    docker-buildx-plugin_0.30.1-1~ubuntu.24.04~noble_arm64.deb \
    docker-compose-plugin_5.0.1-1~ubuntu.24.04~noble_arm64.deb \
	 )
 for i in ${pkg_docker_arr[*]}
   do
     # $sudo apt install $i -y
     sudo dpkg -i $HOME/gits/vlab-rpi/docker/$i
   done 
fi

