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

#### 6. Running Docker Compose File

```yaml
# docker-compose file
# Purpose: This file will spin up all the required services which are required for application to run
# Prerequisite: sudo chown root:root secrets/* && sudo chown root:root configmaps/*
# Notes: The database and kite-websocket should have only one process to avoid read-write conflict
# Use: docker-compose -f docker-compose.yaml up -d

version: '3.8'
services:

  selenium:
    image: selenium/standalone-chrome
    ports:
      - 4444:4444
    container_name: selenium
    restart: on-failure
    networks:
      default:
        aliases:
          - selenium
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://localhost:4444/"]
      interval: 1s
      timeout: 3s
      retries: 30

  kite-login:
    image: sghoshpzs/geldsack:v2
    command: bash -c "python api/kite/kite_login.py"
    depends_on:
      selenium:
        condition: service_healthy
    env_file:
      - .env
    user: root
    environment:
      - APP_NAME=kite-login
      - TZ=Asia/Kolkata
    volumes:
      - ./configmaps:/geldsack/configmaps:Z
      - ./secrets:/geldsack/secrets:Z
      - ./log:/geldsack/log:Z
    container_name: kite-login
    networks:
      default:
        aliases:
          - kite-login

  db:
    image: sghoshpzs/geldsack:v2
    command: flask run --host=0.0.0.0 --port=5000
    # command: gunicorn --pythonpath '/geldsack' api.database.master_db:app -w 1 -b 0.0.0.0:5000
    environment:
      - FLASK_APP=/geldsack/api/database/master_db.py
      - APP_NAME=db
      - TZ=Asia/Kolkata
    env_file:
      - .env
    user: root
    ports:
      - 5000:5000
    volumes:
      - ./configmaps:/geldsack/configmaps:Z
      - ./secrets:/geldsack/secrets:Z
      - ./log:/geldsack/log:Z
      - ./db:/geldsack/db:Z
    container_name: db
    restart: on-failure
    networks:
      default:
        aliases:
          - database
    healthcheck:
      test: ["CMD", "curl", "--fail", "http://db:5000/"]
      interval: 60s
      timeout: 3s
      retries: 30

  kite-api:
    image: sghoshpzs/geldsack:v2
    # command: flask run --host=0.0.0.0 --port=5100
    command: bash -c "sleep 60 && gunicorn --pythonpath '/geldsack' api.kite.kite_api:app -w 1 -b 0.0.0.0:5100"
    # depends_on:
    #   db:
    #     condition: service_healthy
    environment:
      - FLASK_APP=/geldsack/api/kite/kite_api.py
      - APP_NAME=kite-api
      - TZ=Asia/Kolkata
    env_file:
      - .env
    user: root
    ports:
      - 5100:5100
    volumes:
      - ./configmaps:/geldsack/configmaps:Z
      - ./secrets:/geldsack/secrets:Z
      - ./log:/geldsack/log:Z
    container_name: kite-api
    restart: on-failure
    networks:
      default:
        aliases:
          - kite-api
```
