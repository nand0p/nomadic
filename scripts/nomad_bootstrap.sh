#!/bin/bash

/usr/local/bin/nomad agent -config /root/nomad_masters.hcl > nomad-masters.log &
