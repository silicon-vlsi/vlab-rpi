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
  echo "  pkg-docker:	Docker pkgs "
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

if [ $1 == "pkg1" ]
then
  echo "########################"
  echo "# INSTALLING ESSENTIAL PKG1 "
  echo "########################"
  pkg1arr=( \
	 vim tree htop chromium \
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
  # Stick to the order.. it may matter
  pkg_docker_arr=( \
    containerd.io_2.2.0-2~ubuntu.24.04~noble_arm64.deb \
    docker-ce_29.1.3-1~ubuntu.24.04~noble_arm64.deb \
    docker-ce-cli_29.1.3-1~ubuntu.24.04~noble_arm64.deb \
    docker-buildx-plugin_0.30.1-1~ubuntu.24.04~noble_arm64.deb \
    docker-compose-plugin_5.0.1-1~ubuntu.24.04~noble_arm64.deb \
	 )
 for i in ${pkg_docker_arr[*]}
   do
     $sudo apt install $i -y
     sudo dpkg -i $i
   done 
fi

