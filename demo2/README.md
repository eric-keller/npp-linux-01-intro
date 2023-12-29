# Introduction

Here, we will be showing some troubleshooting tools that can be useful.

# Setup

We are using the same containerlab yaml file from demo1 (see that README for description).

```
sudo containerlab deploy
```

# Tool1: ping

Ping provides an easy check for reachability and also provides round trip time.  Note - you'll need to set some ip addresses in the host1 and switch first, then you can ping from the host to the switch.

```
docker exec -it clab-lab1-part1-host1 ip addr add 192.168.1.2/24 dev eth1

docker exec -it clab-lab1-part1-switch ip addr add 192.168.1.1/24 dev eth1

docker exec -it clab-lab1-part1-host1 ping -c 4 192.168.1.1
```

# Tool2: tshark

tshark is a network analyzer.  We'll just show an example how to run it here in a simple case to capture all traffic on eth1 of the switch.  When you do the ping from host1, you should see it in the output of tshark.  It is suggested you run these in separate terminals (either two ssh sessions, or use tmux)  

```
docker exec -it clab-lab1-part1-switch tshark -i eth1

docker exec -it clab-lab1-part1-host1 ping 192.168.1.1
```

# Cleaning up

You can tear down the lab, which will stop and delete all of the running containers, with the following command.

```
sudo containerlab destroy
```

