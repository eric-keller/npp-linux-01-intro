#!/usr/bin/bash

# This needs to be run from the same directory as the containerlab yml file exits 
#  should be run as ./provided/capture_submission.sh

# It will create a directory submission and a file submission.tgz
# The directories lab-host* need to exist, as does the directory provided (which will contain onepkt.py)

# There needs to be a file ./do-lab.sh which contains all commands needed for the lab
# They should be a series of docker exec commands in a script (and other things if needed):

#    #!/usr/bin/bash
#    # docker exec <container name> <command to run in container>
#    # example from change_mac_addrs.sh
#    docker exec clab-lab1-part1-switch ip link set dev eth1 address aa:bb:cc:11:22:11



# if submission dir exists, stop here
if [ -d "./submission" ] || [ -f "submission.tgz" ]
then
    echo "Submission exists.  This script creates the submission directory and submission.tgz file.  Please remove or move and re-run this script." 
    exit 1
fi


if ! [ -f "./do-lab.sh" ]; then
    echo "do-lab.sh does not exist.  Please create and re-run this script."
fi


# check dirs (lab-host1, lab-host2, lab-host3, lab-host4, provided)
dirs=( lab-host1 lab-host2 lab-host3 lab-host4 provided)
for i in "${dirs[@]}"
do
   if ! [ -d $i ]; then
      echo "Directory $i does not exist.  Exiting."
      exit 2
   else
      if [ -f $i/*.pcap ]; then
	 echo "Directory $i has a pcap file.  Delete or move and re-run this script."
         exit 3
      fi
   fi 
done


# Check if containerlab is running
# exit code of 0 if it is
# exit code of 1 if it is not
#sudo containerlab inspect 1> /dev/null 2> /dev/null
#if [ $? -eq 0 ]; then
#  echo "Containerlab is already running.  Please exit it with 'sudo containerlab destroy' then re-run this script"
#  exit 3
#fi


# containerlab deploy
sudo containerlab deploy
if [ $? -ne 0 ]; then
  echo "Containerlab deploy failed. Check if it is running 'sudo containerlab inspect'.  Check if the yaml file exits.  Please correct then re-run this script"
  exit 3
fi


# Change mac addresses 
chmod +x ./provided/change_mac_addrs.sh
./provided/change_mac_addrs.sh


# Execute Student provided script to configure per instructions of the lab
./do-lab.sh


# clear pcap files
docker exec clab-lab1-part1-host1 touch /lab-folder/h1.pcap
docker exec clab-lab1-part1-host2 touch /lab-folder/h2.pcap
docker exec clab-lab1-part1-host3 touch /lab-folder/h3.pcap
docker exec clab-lab1-part1-host4 touch /lab-folder/h4.pcap

# start packet capture in background
docker exec clab-lab1-part1-host1 tshark -i eth1 -f "host 1.1.1.1" -w /lab-folder/h1.pcap &
pid1=$!
docker exec clab-lab1-part1-host2 tshark -i eth1 -f "host 1.1.1.1" -w /lab-folder/h2.pcap &
pid2=$!
docker exec clab-lab1-part1-host3 tshark -i eth1 -f "host 1.1.1.1" -w /lab-folder/h3.pcap &
pid3=$!
docker exec clab-lab1-part1-host4 tshark -i eth1 -f "host 1.1.1.1" -w /lab-folder/h4.pcap &
pid4=$!

#echo $pid



# copy ./provided/onepkt.py to each of lab-host1, lab-host2, etc...
cp ./provided/onepkt.py ./lab-host1
cp ./provided/onepkt.py ./lab-host2
cp ./provided/onepkt.py ./lab-host3
cp ./provided/onepkt.py ./lab-host4


# Packet tests
# host1 to host2
docker exec clab-lab1-part1-host1 /lab-folder/onepkt.py host1 host2 test-pkt1

# host2 to host3
docker exec clab-lab1-part1-host2 /lab-folder/onepkt.py host2 host3 test-pkt2

# host3 to host2
docker exec clab-lab1-part1-host3 /lab-folder/onepkt.py host3 host2 test-pkt3

# host1 to host3
docker exec clab-lab1-part1-host1 /lab-folder/onepkt.py host1 host3 test-pkt4

# host4 to all
docker exec clab-lab1-part1-host4 /lab-folder/onepkt.py host4 all_hosts test-pkt5



# Stop captures
kill $pid1
kill $pid2
kill $pid3
kill $pid4

# Shut down the containerlab setup
sudo containerlab destroy

mkdir submission
mv lab-host1/h1.pcap ./submission
mv lab-host2/h2.pcap ./submission
mv lab-host3/h3.pcap ./submission
mv lab-host4/h4.pcap ./submission
tar czf submission.tgz ./submission



