#! /usr/bin/env python3

import sys
from scapy.all import *


if __name__ == '__main__':
    usage_string = """Usage:
  onepkt.py <src-mac> <dst-mac> <iface> <msg>
    where <msg> is unique identifier for this message"""

    # total arguments
    if (len(sys.argv) != 5):
        sys.exit("Incorrect usage - num args.\n"+usage_string)

    src_mac = sys.argv[1]
    dst_mac = sys.argv[2]
    iface = sys.argv[3]
    msg = sys.argv[4]

    src_ip = "1.1.1.1"
    dst_ip = "2.2.2.2"
    sport = 1111
    dport = 2222


    

    pkt = Ether(dst=dst_mac, src=src_mac) / IP (src=src_ip, dst=dst_ip) / TCP(sport=sport, dport=dport) / msg

    #pkt.show()

    sendp(pkt, iface=iface)

    #sendp(Ether(dst="aa:bb:cc:11:11:33", src="aa:bb:cc:11:11:11") / IP()/"HELLO", iface='eth1.9')


