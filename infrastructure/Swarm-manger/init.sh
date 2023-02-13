#!/usr/bin/env bash


sudo su
mkdir -p /steps
touch /steps/step001
sudo apt update

sudo rm -rf /root/.ssh/authorized_keys
sudo cp  /home/ubuntu/.ssh/authorized_keys /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys
sudo touch /steps/step002
