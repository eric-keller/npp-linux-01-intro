# Introduction

In this demo, we go one step further and configure the nodes, use tshark to monitor traffic, and introduce a scapy script to generate packets.  We provide commands to create a bridge, and then you can take it further.


# Setup

We created a new topology with 2 hosts and 1 switch and named it mod1-devconfig.  The containerlab configuration file is 2node-mod1.clab.yml.

Note binds (e.g., for the switch node, there is a bind statement mod1-switch:/lab-folder, which will bind the mod1-switch directory in the host to /lab-folder in the container).  But, those directories all need to exist before you deploy the lab.  host1 also requires the onepkt.py script to exist.

```
mkdir mod1-host1 mod1-host2 mod1-switch
cp onepkt.py mod1-host1
```

Once the directories are created, you can deploy the lab.

```
sudo containerlab deploy
```

Provided is a [scapy](https://scapy.net/) script, onepkt.py, which allows us to craft a single frame with specific src and dest MAC addresses, specify which interface to sent it out, and what message to include in the payload.  It'll default to using a fixed IP and TCP header, which you can change if you want - just edit the python code.  Note: to make this accessible to be run from within a container, you need to copy it into one of the directories we created above.  e.g., if you want to run it from host1 - copy it to mod1-host1, and in host1 it will exist as /lab-folder/onepkt.py.  

```
onepkt.py <src-mac> <dst-mac> <iface> <msg>
```

Also provided is a file make_aliases.sh which will create some aliases for running commands in each node - instead of running docker exec... <command>, we can just run h1 <command>.  See the README in demo for more info.

```
source make_aliases.sh
```

# Suggested Steps

Here, we'll create a bridge.


On h2 run tshark, and on h1 use onepkt.py to craft and send a packet.  With tshark, we included the vlan and vxlan fields in case you want to try creating some VLAN and VXLAN traffic

```
h2 tshark -T fields -e eth -e vlan -e vxlan -i eth1
h1 python3 /lab-folder/onepkt.py 22:11:11:11:11:11 22:22:22:22:22:22 eth1 123
```

You shouldn't see anything.  Let's look on the switch.  You should see the frame arriving on switch.

```
sw tshark -T fields -e eth -e vlan -e vxlan -i eth1
h1 python3 /lab-folder/onepkt.py 22:11:11:11:11:11 22:22:22:22:22:22 eth1 123
```

The reason why you didn't see anything on host2, was that we didn't configure the switch yet.  Here, we'll set up a bridge.

```
sw   ip link add name mybridge type bridge
sw   ip link set mybridge up
sw   ip link set eth1 master mybridge
sw   ip link set eth2 master mybridge
```

Now, when you re-run the initial set of commands, you should see it on host2

```
h2 tshark -T fields -e eth -e vlan -e vxlan -i eth1
h1 python3 /lab-folder/onepkt.py 22:11:11:11:11:11 22:22:22:22:22:22 eth1 123
```

Now, let's create a VLAN interface on h1, and send traffic through it.

```
h1   ip link add link eth1 name eth1.2 type vlan id 2
h1   ip link set eth1.2 up

sw tshark -T fields -e eth -e vlan -i eth1

h1 python3 /lab-folder/onepkt.py 22:11:11:11:11:11 22:22:22:22:22:22 eth1 123
h1 python3 /lab-folder/onepkt.py 22:11:11:11:11:11 22:22:22:22:22:22 eth1.2 123
```

# Side note

Sometimes when you copy from a website or pdf, some extra characters get added to what you pasted (e.g., ^[[200~ ).  To disable this, run the following command:


```
set enable-bracketed-paste Off
```


# Cleaning up

You can tear down the lab, which will stop and delete all of the running containers, with the following command.

```
sudo containerlab destroy
```

