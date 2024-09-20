# Introduction

This readme includes guidance for users using Mac M1/M2 (ARM) machines and working with the demos/labs for the coursera course: `Network Principles in Practice: Linux`.

The standard approach for the course labs is to use Vagrant VMs (with VirtualBox) which include multiple tools, including a containerlabs installation.

This approach can experience various difficulties running properly on Mac M1/M2 (ARM) machines.  One of the primary issues being that containerlabs does not currently provide native support for Mac ARM.

As a course supported alternative, the following guidance is derived from the containerlabs guidance [here](https://containerlab.dev/install/#arm) and can be used for running the course demos/labs on Mac M1/M2.  This approach utilizes UTM and Ubuntu.

# UTM

UTM is a popular system emulator and virtual machine host for macOS.

This will provide an alternative to Vagrant/VirtualBox and will allow you to build and run an emulated x86_64 Linux machine on Mac M1/M2 (ARM) machines.

You can get and install UTM [here](https://mac.getutm.app/).

# Ubuntu 22.04

Containerlab provides a custom built debian image to support running on ARM.

The course supported guidance recognizes this may work for the demos/labs but this guidance suggests to build a UTM machine with Ubuntu 22.04, to minimize any differences with the original Vagrant build for these labs.

Download the Ubuntu 22.04 **Server install image** ISO [here](https://www.releases.ubuntu.com/22.04/).

**DO NOT** use the Desktop image.  It will perform significantly slower than the Server image within UTM.

# Ubuntu VM Image Build Process via UTM

1. Install UTM
2. Download Ubuntu 22.04 amd64 ISO
3. Add machine to UTM using Emulate Linux options
4. Mount Ubuntu ISO
5. Use remaining UTM defaults
6. Start VM
7. Complete Ubuntu Install using installer defaults
8. Use 'vagrant' for the server name, user name, and password to minimize any differences with the Vagrant build
9. Once the Ubuntu installation is complete, it will ask to reboot.  Do not do this.  Instead, shut the VM down and then unmount the iso in UTM before starting the VM again. If you reboot while the iso is still mounted, the installation will start again
10. Start the VM and confirm you can login
11. Recommended to shut the VM down again and then clone that image within UTM to have a clean copy to start setup for each lab
12. Recommended to check and change the MAC Address configuration for each lab VM within UTM.  The Random generation option can be used.  Otherwise multiple VMs running concurrently in UTM could have conflicting MAC addresses

# Demo/Lab Setup
Once the above is completed, you should have a clean UTM/Ubuntu VM ready to start any setup required for each demo/lab.

To finish the setup for a given demo/lab on the VM, install any additional required components on the VM first.  Check the provision shell block in the Vagrantfile to see the installation commands.  Execute each line of that block individually on the VM.  You may find you need to run the line as sudo and each line should succeed before executing the next line.

For example, given a Vagrantfile provision shell block as follows:
```
config.vm.provision "shell", inline: <<-SHELL
  apt update
	 apt install net-tools
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh --version 24.0.5
	 usermod -aG docker vagrant 
	 newgrp docker
	 bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.44.0
  SHELL
```
you can run:
```
sudo apt update
sudo apt install net-tools
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh --version 24.0.5
sudo usermod -aG docker vagrant 
sudo newgrp docker
sudo bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.44.0
```

Once the above is completed, you can clone the git repo for a given demo/lab within the VM.

At this point you can bypass any Vagrant commands and can run the demo/lab as if you had already run `vagrant up` and connected to the VM via ssh.

# Using Host Default Terminal & SCP to open multiple displays and copy files to your host OS.
UTM's multiple display feature doesn't always work well with the Apple ARM machines.

Using port forwarding, you can both use your native iTerm (or whatever terminal you prefer) to create multiple connections to the UTM VM and copy files between your VM and host OS.
Taken from [Arteen's UCLA Blog](https://arteen.linux.ucla.edu/ssh-into-utm-vm.html)

1. Ensure the VM is stopped - UTM won't allow settings changes on a running VM.
2. Navigate to the Edit dialog by either:
   - Right clicking on the VM -> Edit.
   - Left clicking on the VM -> Click Edit button in the upper right hand corner of the UTM window.
3. Under the Network tab, change Network mode to "Emulated VLAN".
4. A new Port Forwarding tab should populate, use this tab to create a new port forward with guest port 22 and host port any number (initial tutorial suggests 2222).
5. Start the VM. When startup completes, run `sudo systemctl start sshd`
6. You can now run `ssh user@localhost -p 2222` from your host terminal to create an ssh session or `scp -P 2222 vagrant@localhost:/path/to/file /path/to/destination` to copy files to your root host.


# License

For all files in this repo, we follow the MIT license.  See LICENSE file.
