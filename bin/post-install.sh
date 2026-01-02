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
  pkg_docker_arr=( \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
	 )
 for i in ${pkg_docker_arr[*]}
   do
     sudo apt install $i -y
   done 
fi

