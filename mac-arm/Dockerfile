FROM ubuntu:jammy

RUN apt update
RUN apt install -y tshark
RUN apt install -y net-tools iproute2 python3 python3-pip

RUN pip3 install scapy

# docker build . -t ubuntu_jammy:lab_1