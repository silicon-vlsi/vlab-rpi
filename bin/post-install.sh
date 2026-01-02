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

