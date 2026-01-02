#!/bin/bash
#
if [ $# -ne 1 ]
then 
  echo " "
  echo "Usage: $0 <options>"
  echo " "
  echo "DESCRIPTION: Options are "
  echo "  update:	Update the distro"
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
