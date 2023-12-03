#! /usr/bin/env python3

import sys
from scapy.all import *


if __name__ == '__main__':
    usage_string = """Usage:
  onepkt.py <from> <to> <msg>
    where <from> is one of host1, host2, host3, host4
           <to> is one of host1, host2, host3, host4, all_hosts
           <msg> is unique identifier for this message"""

    # total arguments
    if (len(sys.argv) != 4):
        sys.exit("Incorrect usage - num args.\n"+usage_string)

    fr = sys.argv[1]
    to = sys.argv[2]
    msg = sys.argv[3]

    host_addrs = ["aa:bb:cc:11:11:11","aa:bb:cc:11:11:22","aa:bb:cc:11:11:33","aa:bb:cc:11:11:44"]

    if (fr.startswith("host")):
       ix = fr[-1]
    if (not ix.isdigit()):
        sys.exit("Incorrect usage - from\n"+usage_string)

    src_mac = host_addrs[int(ix)-1]

    if(to == "all_hosts"):
        dst_mac = "ff:ff:ff:ff:ff:ff"
    elif (to.startswith("host")):
        ix = to[-1]
        if (not ix.isdigit()):
            sys.exit("Incorrect usage - to"+usage_string)
        dst_mac = host_addrs[int(ix)-1]

    src_ip = "1.1.1.1"
    dst_ip = "2.2.2.2"
    sport = 1111
    dport = 2222


    

    pkt = Ether(dst=dst_mac, src=src_mac) / IP (src=src_ip, dst=dst_ip) / TCP(sport=sport, dport=dport) / msg

    #pkt.show()

    sendp(pkt, iface="eth1")

    #sendp(Ether(dst="aa:bb:cc:11:11:33", src="aa:bb:cc:11:11:11") / IP()/"HELLO", iface='eth1.9')


