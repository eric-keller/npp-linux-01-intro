#!/usr/bin/bash

# INCLUDE ALL COMMANDS NEEDED TO PERFORM THE LAB
# This file will get called from capture_submission.sh


echo "  Create bridge in the switch container"
docker exec clab-lab1-part1-switch ip link add mybridge type bridge
docker exec clab-lab1-part1-switch ip link set mybridge up

echo "  Add interfaces to the bridge"
docker exec clab-lab1-part1-switch ip link set eth1 master mybridge
docker exec clab-lab1-part1-switch ip link set eth2 master mybridge
docker exec clab-lab1-part1-switch ip link set eth3 master mybridge
docker exec clab-lab1-part1-switch ip link set eth4 master mybridge

echo "  Make sure all interfaces are up"
docker exec clab-lab1-part1-switch ip link set eth1 up
docker exec clab-lab1-part1-switch ip link set eth2 up
docker exec clab-lab1-part1-switch ip link set eth3 up
docker exec clab-lab1-part1-switch ip link set eth4 up