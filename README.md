# <span style="color: blue">Infrastructure Provisioning for Geldsack </span>
[![](https://img.shields.io/badge/Terraform-blue?style=for-the-badge)](https://github.com/hamzamohdzubair/redant)
[![](https://img.shields.io/badge/AWS-yellow?style=for-the-badge)](https://docs.rs/crate/redant/latest)

## <span style="color: blue"> Description </span>

This project is created for provisioning the AWS infrastructre for running Geldsack. This can be deployed manually or using github workflow.

## <span style="color: blue"> Architecture </span>


## <span style="color: blue"> Tasks </span>

Following feature will be configured in the launched EC2 instance-

#### 1. Update Amazon Linux & download required binaries

```bash
sudo yum update -y
sudo yum install -y docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
```

#### 2. Get root privilege

```bash
sudo usermod -aG wheel ec2-user
sudo usermod -aG docker ec2-user
sudo chmod +x /usr/local/bin/docker-compose
```

#### 3. Get secrets from Hasicorp Vault



#### 4. Start services

```bash
systemctl start docker
docker login -u sghoshpzs
docker pull selenium:latest
docker pull sghoshpzs/geldsack:v3
```

#### 5. Create required folders
```bash
mkdir geldsack
mkdir geldsack/configmaps
mkdir geldsack/secrets
mkdir geldsack/log
```
