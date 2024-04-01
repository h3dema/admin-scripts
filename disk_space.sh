#!/bin.bash
#
#
# This script connects to the computers listed in `SERVERS` and lists the available disk space on each of them.
#
# TODO: 
# =====
# Note that this script can be adapted, using a variable with a defined threshold, to identify disks that should be considered full. 
# Hosts that have reached (or exceeded) this threshold must be informed via email to the administrator.
#
# Example:
# ========
# bash disk_space.sh
#

# list of hostnames or ip addresses (separated by spaces)
SERVERS="nuc-vms nuc-dell"
SSH_PORT=22
for s in $SERVERS; do
    echo "checking space in <<< $s >>>"
    ssh -p $SSH_PORT root@$s "/bin/df -h | /bin/grep '\ /$'"
done
