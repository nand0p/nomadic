#!/bin/bash -ex


echo get cluster node ip address
LOCAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)


echo install dependencies
yum -y update
yum -y install git nmap nc htop yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo


echo clone nomadic repo
git clone https://github.com/nand0p/nomadic.git /root/nomadic


echo install service packages
yum -y install docker consul nomad vault
systemctl enable docker
systemctl start docker


echo configure cluster nodes
aws ssm get-parameter \
  --with-decryption \
  --region us-east-1 \
  --name nomadic_ssh_key \
  --output text \
  --query Parameter.Value | tee /home/ec2-user/.ssh/id_rsa
chown -c ec2-user. /home/ec2-user/.ssh/id_rsa
chmod -c 0400 /home/ec2-user/.ssh/id_rsa
echo "${PRIVATE_IP_ONE} nomadic1" | tee -a /etc/hosts
echo "${PRIVATE_IP_TWO} nomadic2" | tee -a /etc/hosts
echo "${PRIVATE_IP_THREE} nomadic3" | tee -a /etc/hosts
cat /etc/hosts
if [ "${PRIVATE_IP_ONE}" == "$${LOCAL_IP}" ]; then
   hostnamectl set-hostname nomadic1
elif [ "${PRIVATE_IP_TWO}" == "$${LOCAL_IP}" ]; then
   hostnamectl set-hostname nomadic2
elif [ "${PRIVATE_IP_THREE}" == "$${LOCAL_IP}" ]; then
   hostnamectl set-hostname nomadic3
fi
hostname


echo configure consul
wget -O /etc/consul.d/consul.hcl https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/bootstrap/consul.hcl
wget -O /etc/consul.d/consul.env https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/bootstrap/consul.env
CONSUL_KEY=$(aws ssm get-parameter --with-decryption --region us-east-1 --name consul_encryption_key --output text --query Parameter.Value)
sed -i "s|CONSUL_ENCRYPTION_KEY|$${CONSUL_KEY}|g" /etc/consul.d/consul.hcl
sed -i "s|NOMADIC_ONE_IP|${PRIVATE_IP_ONE}|g" /etc/consul.d/consul.hcl
sed -i "s|NOMADIC_TWO_IP|${PRIVATE_IP_TWO}|g" /etc/consul.d/consul.hcl
sed -i "s|NOMADIC_THREE_IP|${PRIVATE_IP_THREE}|g" /etc/consul.d/consul.hcl
if [ "${PRIVATE_IP_ONE}" == "$${LOCAL_IP}" ]; then
  echo "advertise_addr = \"${PRIVATE_IP_ONE}\"" | tee -a /etc/consul.d/consul.hcl
  echo "client_addr = \"127.0.0.1 ${PRIVATE_IP_ONE}\"" | tee -a /etc/consul.d/consul.hcl
elif [ "${PRIVATE_IP_TWO}" == "$${LOCAL_IP}" ]; then
  echo "advertise_addr = \"${PRIVATE_IP_TWO}\"" | tee -a /etc/consul.d/consul.hcl
  echo "client_addr = \"127.0.0.1 ${PRIVATE_IP_TWO}\"" | tee -a /etc/consul.d/consul.hcl
elif [ "${PRIVATE_IP_THREE}" == "$${LOCAL_IP}" ]; then
  echo "advertise_addr = \"${PRIVATE_IP_THREE}\"" | tee -a /etc/consul.d/consul.hcl
  echo "client_addr = \"127.0.0.1 ${PRIVATE_IP_THREE}\"" | tee -a /etc/consul.d/consul.hcl
fi
cat /etc/consul.d/consul.hcl
systemctl enable consul
systemctl start consul


echo configure nomad
mv -v /etc/nomad.d/nomad.hcl /etc/nomad.d/nomad.hcl.orig
wget -O /etc/nomad.d/nomad.hcl https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/bootstrap/nomad.hcl
wget -O /etc/nomad.d/nomad.env https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/bootstrap/nomad.env
sed -i "s|NOMADIC_ONE_IP|${PRIVATE_IP_ONE}|g" /etc/nomad.d/nomad.hcl
sed -i "s|NOMADIC_TWO_IP|${PRIVATE_IP_TWO}|g" /etc/nomad.d/nomad.hcl
sed -i "s|NOMADIC_THREE_IP|${PRIVATE_IP_THREE}|g" /etc/nomad.d/nomad.hcl
cat /etc/nomad.d/nomad.hcl
systemctl enable nomad
systemctl start nomad


echo configure vault
echo "export VAULT_API_ADDR=https://vault.nomadic.red:8200" | tee /etc/profile.d/vault_api_addr.sh
echo "127.0.0.1 vault.nomadic.red" | tee -a /etc/hosts
mv -v /etc/vault.d/vault.hcl /etc/vault.d/vault.hcl.orig
wget -O /etc/vault.d/vault.hcl https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/bootstrap/vault.hcl
wget -O /etc/vault.d/vault.env https://raw.githubusercontent.com/nand0p/nomadic/${BRANCH}/bootstrap/vault.env
LOCAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
sed -i "s|VAULT_KMS_ID|${VAULT_KMS_ID}|g" /etc/vault.d/vault.hcl
cat /etc/vault.d/vault.hcl
aws ssm get-parameter \
  --with-decryption \
  --name vault.nomadic.red_certchain \
  --region us-east-1 \
  --query Parameter.Value \
  --output text | tee  /opt/vault/tls/tls.crt
aws ssm get-parameter \
  --with-decryption \
  --name vault.nomadic.red_key \
  --region us-east-1 \
  --query Parameter.Value \
  --output text | tee  /opt/vault/tls/tls.key
systemctl enable vault
systemctl start vault
echo pause for cluster
sleep 60
if [ "${PRIVATE_IP_ONE}" == "$${LOCAL_IP}" ]; then
  echo instance is leader
  /usr/bin/vault status -address="https://vault.nomadic.red:8200"| grep Init | tee /root/vault.init
  if grep false /root/vault.init; then
    echo vault initialize
    /usr/bin/vault operator init -address="https://vault.nomadic.red:8200" | tee /root/vault.secret
  fi
fi


echo pause and verify_cluster
which consul
which nomad
which vault
sleep 60
/usr/bin/consul version
/usr/bin/consul info
/usr/bin/consul members
systemctl status consul
journalctl -u consul

/usr/bin/nomad version
/usr/bin/nomad status
/usr/bin/nomad agent-info
systemctl status nomad
journalctl -u nomad

/usr/bin/vault version
/usr/bin/vault status -address="https://vault.nomadic.red:8200"
systemctl status vault
journalctl -u vault
