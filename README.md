# Infrastructure Provisioning for Geldsack

## Description

This project is created for provisioning the AWS infrastructre for running Geldsack. This can be deployed manually or using github workflow.

## Architecture


## Tasks

Following feature will be configured in the launched EC2 instance-

#### Update Amazon Linux & download required binaries

sudo yum update -y
sudo yum install -y docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

#### Get root privilege

sudo usermod -aG wheel ec2-user
sudo usermod -aG docker ec2-user
sudo chmod +x /usr/local/bin/docker-compose

#### Get secrets from Hasicorp Vault



#### Start services

systemctl start docker
docker login -u sghoshpzs
docker pull selenium:latest
docker pull sghoshpzs/geldsack:v3

#### Create required folders

mkdir geldsack
mkdir geldsack/configmaps
mkdir geldsack/secrets
mkdir geldsack/log


