# Lab Instructions

In this lab you need to create a bridge for the provided containerlab topology.  Note - it is the same one we used for demo1 and demo2, but different than what was used demo3 (where we demoed creating a bridge).

Put all of your commands in do-lab.sh


# Provided

4node-part1.clab.yml - the containerlab configuration file

do-lab.sh - where to put all of your commands to perform the lab

provided/capture_submission.sh - when you are ready to submit, run this.  (more details below under How to Submit) 

provided/change_mac_addrs.sh - a convenience script to set the MAC addresses of all interfaces so we're all consistent.  

provided/make_aliases.sh - source this file for the convience of aliases for each node.

provided/make_dirs.sh - a convience script to create the directories that match what is expected in the containerlab config (binds for each node)

provided/onepkt.py - a scapy script to craft and send single packet.  Note, it is different than what was provided in demo3.   It hard codes the MAC addresses for each host, allowing the hostname to be specified as the source/dest.  See below.


# onepkt.py

Usage:
```
onepkt.py <from> <to> <msg>
    where <from> is one of host1, host2, host3, host4
           <to> is one of host1, host2, host3, host4, all_hosts
           <msg> is unique identifier for this message"""
```

So, as an example, to send from host1 to host2.


```
docker exec clab-lab1-part1-host1 /lab-folder/onepkt.py host1 host2 test-pkt1
```

# How to submit

The script capture_submission.sh will run a bunch of stuff, and create a directory submission where it will put output, and then tar and gzip that directory up (into a file submission.tgz).  The submission.tgz is what you will upload to coursera.

Run it from the lab1/part1 directory of the repo (<repodir>/lab1/part1).

```
./provided/capture_submission.sh
```

It will first check if the needed directories and do-lab.sh files exist.

It will then run `sudo containerlab deploy`

It then runs `provided/change_mac_addrs.sh`

It then runs `./do-lab.sh`  (the file with the lab solution)

It then runs tshark in each host, copies onepkt.py to each host, and then a set of test cases.  View capture_submission.sh to see the test cases it runs.

It will then run `sudo containerlab destroy` to clean it up, copy the output to the submission folder, and create the submission tgz.

To re-run it, you may need to delete the previous submission directory.



# License

See LICENSE file in root directory.  MIT license.  Must include attribution to Eric Keller.
