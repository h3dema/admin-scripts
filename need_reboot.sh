#!/bin/bash
#
# This script was developed to run in bash.
# The hosts are specified in the variable called `SERVERS`.
# The host names in this variable are separated by spaces.
# Access to hosts is done via SSH using the root user.
# We consider that the certificates required to access the hosts are configured on the local computer (where this script is executed), 
# so it is not necessary to provide a password for the connection.
# The script will display an on-screen message for each server and indicate whether the server needs to be restarted.
#
# Example:
# ========
# bash need_reboot.sh
#

# hostname or ip address to access the desired host via SSH
#
SERVERS="nuc-vms nuc-dell"

check() {
    # check if reboot is necessary
    # echo "$servername:$port"
    resp=`ssh -p $SSH_PORT root@$servername "if [ -f /var/run/reboot-required ]; then echo \"1\"; else echo \"0\"; fi"`
    if [ $resp -eq 1 ]; then
        echo "=> reboot <<< $servername:$SSH_PORT >>>"
    else
        echo "<<< $servername:$SSH_PORT >>>"
    fi
}

# SSH port to use
SSH_PORT=22
for servername in $SERVERS; do
    check $servername $SSH_PORT
done
