#!/bin/bash
#
if [ $# -ne 1 ]
then 
  echo " "
  echo "Usage: $0 <options>"
  echo " "
  echo "DESCRIPTION: Options are "
  echo "  update:	Update the distro"
  echo "  pkg1:		Essential pkgs (vim, chromium, etc)"
  echo "  apt-docker:	setup apt repo for docker " 
  echo "  pkg-docker:	Docker pkgs "
  echo "  setup-osic:   Setup /opt/IIC-OSIC-TOOLS with right perms"	
  echo "  start-ic:	Create the /usr/local/bin/start-ic.sh script"
  echo "  create-users:	Creates bulk users (RUN AS SUDO) "
  
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

if [ $1 == "start-ic" ]
then
  echo "########################"
  echo "# CREATING /usr/local/bin/start-ic.sh "
  echo "########################"
  sudo tee /usr/local/bin/start-ic.sh <<EOF
#!/bin/bash
#
export DESIGNS=\$HOME/eda/designs
export DOCKER_TAG=2025.12
cd /opt/IIC-OSIC-TOOLS
./start_x.sh
EOF
  sudo chmod +x /usr/local/bin/start-ic.sh
fi

if [ $1 == "apt-docker" ]
then
  echo "########################"
  echo "# Setting up apt repo for docker "
  echo "########################"
  # Add Docker's official GPG key:
  sudo apt update -y
  sudo apt install ca-certificates curl -y
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  sudo apt update -y
fi

if [ $1 == "setup-osic" ]
then
  echo "########################"
  echo "# SETTING /opt/IIC-OSIC-TOOLS "
  echo "########################"
  cd /opt
  sudo git clone --depth 1 https://github.com/iic-jku/IIC-OSIC-TOOLS.git
  sudo chown -R root:users IIC-OSIC-TOOLS
  sudo chmod -R 755 IIC-OSIC-TOOLS
  echo "Downloading iic-osic-tools.tar ....will take some time.."
  sudo wget http://192.168.11.237/repos/share/iic-osic-tools.tar
  sync
  echo "Loading the docker"
  sudo docker load -i iic-osic-tools.tar
fi

if [ $1 == "pkg1" ]
then
  echo "########################"
  echo "# INSTALLING ESSENTIAL PKG1 "
  echo "########################"
  pkg1arr=( \
	 vim tree htop \
	 iverilog gtkwave \
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
  #pkg_docker_arr=( \
  #  containerd.io_2.2.1-1~ubuntu.24.04~noble_arm64.deb \
  #  docker-ce-cli_29.1.3-1~ubuntu.24.04~noble_arm64.deb \
  #  docker-ce_29.1.3-1~ubuntu.24.04~noble_arm64.deb \
  #  docker-buildx-plugin_0.30.1-1~ubuntu.24.04~noble_arm64.deb \
  #  docker-compose-plugin_5.0.1-1~ubuntu.24.04~noble_arm64.deb \
  #	 )
  pkg_docker_arr=( \
    containerd.io \
    docker-ce-cli \
    docker-ce \
    docker-buildx-plugin \
    docker-compose-plugin \
	 )

  for i in ${pkg_docker_arr[*]}
    do
      sudo apt install $i -y
      #sudo dpkg -i $HOME/gits/vlab-rpi/docker/deb-files/$i
    done 

   #Comment the install below if gives problem and enable above 
   sudo apt update -y
   sudo apt upgrade -y
   sudo apt autoremove -y
fi


## This section requires sudo 
if [ $1 == "create-users" ]
then
	#
# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

  echo "########################"
  echo "# APPENDING /etc/skel/.bashrc"
  echo "########################"
  tee -a /etc/skel/.bashrc <<EOF

#CUSTOMIZATION
alias date='date +%D'
alias h='history'
alias vimr='vim -R'
alias rm='rm -i'
alias du10='du -BM -s * .[^.]* | sort -n | tail -10'
EOF

# Number of users to create
NUM_USERS=50

# Create temporary file for chpasswd
TEMP_FILE=$(mktemp)

# Loop to generate users
for i in $(seq -f "%02g" 1 $NUM_USERS); do
    USER="ulab$i"
    PASS="@lab$i"
    
    # Skip if user already exists
    if id "$USER" &>/dev/null; then
        echo "User $USER already exists, skipping."
    else
        # Create user with home directory
        useradd -m -s /bin/bash -G docker,users "$USER"
        # Add to chpasswd input
        echo "$USER:$PASS" >> "$TEMP_FILE"
        echo "Created user: $USER with password: $PASS"
	echo " "
	##Create persistent directory for the docker IIC-OSIC-TOOLS
	echo "Creating /home/$USER/eda/designs and setting perm.."
	mkdir -p /home/$USER/eda/designs
	chown -R $USER:$USER /home/$USER/eda
	chmod -R 755 /home/$USER/eda
    fi
done

# Set passwords in batch
chpasswd < "$TEMP_FILE"

# Cleanup
rm "$TEMP_FILE"

echo "Created $NUM_USERS users successfully."
fi

