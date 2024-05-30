# Introduction

This readme includes guidance for users using Mac M1/M2 (ARM) machines and working with the demos/labs for the coursera course: `Network Principles in Practice: Linux`.

The standard approach for the course labs is to use Vagrant VMs which include multiple tools, including a containerlabs installation.

This approach can experience difficulties running properly on Mac M1/M2 (ARM) machines due to containerlabs which does not provide native support for Mac ARM.

As a course supported alternative, the following guidance is derived from the containerlabs guidance [here](https://containerlab.dev/install/#arm) and can be used for running the course demos/labs on Mac M1/M2.  This approach utilizes UTM and Ubuntu.

# UTM

UTM is a popular system emulator and virtual machine host for macOS.

This will provide an alternative to Vagrant and will allow you to build and run an emulated x86_64 Linux machine on Mac M1/M2 (ARM) machines.

You can get and install UTM [here](https://mac.getutm.app/).

# Ubuntu 22.04

Containerlab provides a custom built debian image to support running on ARM.

The course supported guidance recognizes this may work for the demos/labs but this guidance suggests to build a UTM machine with Ubuntu 22.04, to minimize any differences with the original Vagrant build for these labs.

Download the Ubuntu 22.04 amd64 ISO [here](https://www.releases.ubuntu.com/22.04/ubuntu-22.04.4-live-server-amd64.iso).

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

# Lab Setup
Once the above is completed, you should have a clean UTM/Ubuntu VM ready to start any setup required for each demo/lab.

To setup for a given demo/lab, install any additional required components on the VM first.  Check the config.vm.provision "shell", inline: <<-SHELL block of the Vagrant file for that demo/lab.  Execute each line of that block individually and as sudo on the VM.  Each line should succeed before executing the next line.

Clone the git repo for a given demo/lab within the VM.

At this point you should be able to complete the demo/lab.

# License

For all files in this repo, we follow the MIT license.  See LICENSE file.
