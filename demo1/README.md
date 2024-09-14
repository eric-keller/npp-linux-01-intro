# Introduction

In this demo, we're illustrating the lab environment we will be using.

We will use [Containerlab](https://containerlab.dev/).  The Vagrantfile provided in the root directory of this repo will install both Docker and Containerlab.  We will fix it at a specific version to be installed to maximize the liklihood that code provided works.

# Suggested Steps

Open the Containerlab YAML file.  Note that it is using the `ekellercu/network-testing:v0.1` [docker container](https://hub.docker.com/r/ekellercu/network-testing), which contains a bunch of network utilities installed (see the docker hub page for more specifics).

```
vi 4node-part1.clab.yml
```

Make sure the directories are created which will bind to the containers' lab-folder directory.

```
mkdir lab-host1 lab-host2 lab-host3 lab-host4 lab-switch
```

To deploy, run the following command.  This will launch containers and wire them together as specified in the yaml file.

```
sudo containerlab deploy
```

The container names will all be printed out, but they all follow a similar format: `clab-<name of topology>-<name of node>`.  In the case of the provided yaml file, the name of the topology was lab1-part1, and an example name of a node was host1.  So, clab-lab1-part1-host1.

With this, you can run some docker commands inside of each container:

```
docker exec -it clab-lab1-part1-host1 ifconfig
docker exec -it clab-lab1-part1-host1 bash
```


It may be useful to create some aliases for running the various containers.  e.g., below we create an alias for the prefix for all commands to run insied of the host1 container.  We can then just say host1 <command> to execute a command inside of that container.

```
alias host1=“docker exec -it clab-lab1-part1-host1”
host1 ifconfig
```
# Cleaning up

You can tear down the lab, which will stop and delete all of the running containers, with the following command.

```
sudo containerlab destroy
```
