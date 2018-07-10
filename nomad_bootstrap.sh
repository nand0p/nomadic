#!/bin/bash

IP_ADDRESS=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

/usr/local/bin/consul agent -advertise ${IP_ADDRESS} -data-dir consul-data -server -ui > consul.log &
sudo /usr/local/bin/nomad agent -config nomad-config.hcl > nomad.log &
