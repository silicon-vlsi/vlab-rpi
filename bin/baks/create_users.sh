#!/bin/bash

# Number of users to create
NUM_USERS=50

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

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

