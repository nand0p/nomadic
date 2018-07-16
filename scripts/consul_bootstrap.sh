#!/bin/bash

# manual leader
/usr/local/bin/consul agent -advertise $(curl http://169.254.169.254/latest/meta-data/local-ipv4) -data-dir consul-data -server -ui -bootstrap > consul.log &

# server members
/usr/local/bin/consul agent -advertise $(curl http://169.254.169.254/latest/meta-data/local-ipv4) -data-dir consul-data -server -ui -join ${LEADER} > consul.log &
