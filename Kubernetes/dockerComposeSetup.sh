#!/bin/bash
#Script to install docker compose. Remember to log out and log back in after running this script

#Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && apt-cache policy docker-ce
sudo apt-get install -y docker-ce

#Install docker-compose using pip and setup for using docker-compose
sudo apt-get install -y python-pip && pip install docker-compose
sudo usermod -aG docker $USER