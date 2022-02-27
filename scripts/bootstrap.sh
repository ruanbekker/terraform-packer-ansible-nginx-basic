#!/usr/bin/env bash
set -e

# install ansible
sudo apt update -y
sudo apt install python3-pip -y
sudo python3 -m pip install ansible==4.4.0
