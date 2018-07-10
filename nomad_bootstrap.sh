#!/bin/bash

IP_ADDRESS=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

consul agent -advertise ${IP_ADDRESS} -data-dir consul-data -server -bootstrap > consul.log &
nomad agent -config nomad-config.hcl > nomad.log &
