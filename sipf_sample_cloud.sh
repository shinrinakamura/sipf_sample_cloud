#!/bin/bash

# install node-red
sudo apt update
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

# Installation of required nodes
cd .node-red
npm install node-red-contrib-influxdb
npm install node-red-dashboard
cd ..

# Launch the application
sudo systemctl start nodered.service
sudo systemctl enable nodered.service

# install influxdb
sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
sudo echo "deb https://repos.influxdata.com/ubuntu bionic stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt update
sudo apt install -y influxdb
sudo systemctl start influxdb
sudo apt install -y influxdb-client

# create database
influx -execute 'CREATE DATABASE EnvironData'

# install grafana
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt -y install grafana

sudo systemctl daemon-reload
sudo systemctl start grafana-server
