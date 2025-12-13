# admin-scripts

Here I store some simple (and useful) scripts to perform some basic admin task.


- [mgmt_branch](mgmt_branch.sh): simple script to create/delete/merge branches with git.

- [need_reboot](need_reboot.sh): check a list of server to see with they needed reboot due to apt updates.

- [disk_space](disk_space.sh): list the disk space on remote server using SSH

- [myip](myip.sh): get the external IP of a host behind a NAT server. Depends on `curl` and `dig` (dnsutils package)

- [pdftrim](pdftrim.sh): remove the whitespace margim of a pdf document. You need to install `convert` for it to work.