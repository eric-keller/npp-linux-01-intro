# Introduction

This readme includes guidance for users using Mac M1 processors (ARM) or newer machines and working with the demos/labs for the coursera course: `Network Principles in Practice: Linux`.

The approach that is being provided for the course labs is to use Vagrant VMs that are based on VirtualBox in order to run everything.

This approach can experience various difficulties running properly on Mac M1 (ARM) or newer machines. The main issue is that the method here will try to create the VM using an x64 image, while VirtualBox is unable to emulate x64 images on ARM (Mac's with M1 processors or newer).

In order to be able to create a x64 virtual machine on ARM processor (Apple Silicon, M1 or newer), we need to first install QEMU which will be able to do the needed emulation and to use a suitable Vagrandfile. The new Vagrandfile is based on another image that is compatible with QEMU, which is our only way to emulate x64 images. The format of the file is also different compared to the original Vagrandfile, as QEMU has different calls compared to VirtualBox (The original Vagrandfile).



# QEMU

QEMU is an emulation tool that is available on both Linux distributions and MacOS that is able to emulate x64 images on ARM processors (in our case, Apple Silicon - M1 or newer processors).


This will allow us to setup everything that is needed just like you are using it on a normal x64 computer without almost any change to the process


We will need to install QEMU that will handle all the emulations instead of VirtualBox, Vagrand which we will use in this course and the QEMU Vagrand plugin that will allow Vagrand to communicate with QEMU and control the VM's.


First, we will install brew. Brew is a packet manager that will allow us to install all the softwares we need.

In order to install brew, open Terminal in your mac, and run the following:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
When installation is finished, run the following commands one by one:
```
brew install qemu
brew install --cask vagrant
vagrant plugin install vagrant-qemu
```
The first command tells brew to install qemu, the 2nd command tells brew to install Vagrant and the 3rd command tells Vagrant to install the QEMU plugin.


When the installation is over, clone the repository (or download it as ZIP), delete Vagrandfile, and rename Vagrandfile-macos to Vagrandfile.

And that's it! you are ready to go

# License
For all files in this repo, we follow the MIT license.  See LICENSE file.
