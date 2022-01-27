#!/bin/bash


echo install deps
yum -y update
yum -y install htop yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo


echo install servivces
yum -y install docker consul nomad vault


echo configure consul
CONSUL_KEY=$(aws ssm get-parameter --with-decryption --region us-east-1 --name consul_encryption_key --output text --query Parameter.Value)
wget -O /etc/consul.d/consul.hcl https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/boot_scripts/consul.hcl
sed -i "s/CONSUL_ENCRYPTION_KEY/${CONSUL_KEY}/g" /etc/consul.d/consul.hcl
sed -i "s/NOMADIC_ONE_IP/${PRIVATE_IP_ONE}/g" /etc/consul.d/consul.hcl
sed -i "s/NOMADIC_TWO_IP/${PRIVATE_IP_TWO}/g" /etc/consul.d/consul.hcl
sed -i "s/NOMADIC_THREE_IP/${PRIVATE_IP_THREE}/g" /etc/consul.d/consul.hcl
cat /etc/consul.d/consul.hcl


echo configure nomad
mv -v /etc/nomad.d/nomad.hcl /etc/nomad.d/nomad.hcl.orig
wget -O /etc/nomad.d/nomad.hcl https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/boot_scripts/nomad.hcl
sed -i "s/NOMADIC_ONE_IP/${PRIVATE_IP_ONE}/g" /etc/nomad.d/nomad.hcl
sed -i "s/NOMADIC_TWO_IP/${PRIVATE_IP_TWO}/g" /etc/nomad.d/nomad.hcl
sed -i "s/NOMADIC_THREE_IP/${PRIVATE_IP_THREE}/g" /etc/nomad.d/nomad.hcl
cat /etc/nomad.d/nomad.hcl
systemctl enable consul
systemctl stop consul
systemctl start consul


echo configure vault
echo unseal
systemctl enable vault
systemctl stop vault
systemctl start vault


echo pause and verify_cluster
which consul
which nomad
which vault
sleep 30
/usr/bin/consul --version
/usr/bin/consul status
systemctl status consul
journalctl -u consul

/usr/bin/nomad --version
/usr/bin/nomad status
systemctl status nomad
journalctl -u nomad

/usr/bin/vault --version
/usr/bin/vault status
systemctl status vault
journalctl -u vault
