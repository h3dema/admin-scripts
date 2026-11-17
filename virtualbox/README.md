This is a simpler interface to Virtualbox.
It uses the command line program -- VBoxManage -- perform basic tasks on the vm's installed locally.


# Installation

Save the script as vm.sh and make it executable:
```bash
chmod +x vm.sh
```

Optionally, move it to a directory in your PATH:
```bash
sudo install -m 755 vm.sh /usr/local/bin/vm
```

> The script assumes the VBoxManage is installed and in the PATH.
